import Foundation

enum StatisticsState {
    case initial
    case loading
    case data([User])
    case empty
    case failed(Error)
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    weak var view: StatisticsView?

    private let userService: UserServiceProtocol
    
    private var currentTask: NetworkTask?
    private var users: [User] = []
    private var page = 0
    private let size = 15

    private var isLoadingPage = false
    private var hasMorePages = true

    private let sortTypeKey = "statisticsSortType"
    private(set) var currentSortType: StatisticsSortType

    private var state: StatisticsState = .initial {
        didSet {
            stateDidChanged()
        }
    }

    var numberOfUsers: Int {
        users.count
    }

    init(userService: UserServiceProtocol) {
        self.userService = userService

        if let savedValue = UserDefaults.standard.string(forKey: sortTypeKey),
           let savedSortType = StatisticsSortType(rawValue: savedValue) {
            currentSortType = savedSortType
        } else {
            currentSortType = .rating
        }
    }

    func viewDidLoad() {
        state = .loading
    }

    func user(at index: Int) -> User {
        users[index]
    }

    func loadMoreIfNeeded(index: Int) {
        guard index == users.count - 1 else { return }
        loadNextPage()
    }

    func didSelectUser(at index: Int) {
        view?.navigateToProfile(with: users[index])
    }

    func changeSorting(to sortType: StatisticsSortType) {
        guard sortType != currentSortType else { return }

        currentSortType = sortType
        UserDefaults.standard.set(sortType.rawValue, forKey: sortTypeKey)

        sortUsers()
        view?.reloadData()
    }

    private func stateDidChanged() {
        switch state {

        case .initial:
            assertionFailure("can't move to initial state")

        case .loading:
            view?.showLoading()
            loadNextPage()

        case .data:
            view?.hideLoading()
            view?.showTableView()
            view?.reloadData()

        case .empty:
            view?.hideLoading()
            view?.showEmptyView()

        case .failed(let error):
            view?.hideLoading()
            view?.showError(makeErrorModel(error))
        }
    }

    private func loadNextPage() {
        guard !isLoadingPage, hasMorePages else { return }

        isLoadingPage = true
        currentTask = userService.fetchUsers(page: page, size: size) { [weak self] result in
            guard let self else { return }
            self.isLoadingPage = false

            switch result {
            case .success(let (newUsers, fetchedCount)):
                self.page += 1
                self.hasMorePages = fetchedCount == self.size

                self.users.append(contentsOf: newUsers)
                self.sortUsers()

                self.state = self.users.isEmpty ? .empty : .data(self.users)

            case .failure(let error):
                if self.users.isEmpty {
                    self.state = .failed(error)
                } else {
                    self.view?.hideLoading()
                    self.view?.showError(self.makeErrorModel(error))
                }
            }
        }
    }

    deinit {
        currentTask?.cancel()
    }

    /* В ТЗ написано, что сортировка должна быть по рейтингу, который приходит с сервера равным 1 у всех пользователей. Но по ТЗ справа должно быть именно кол-во NFT, а не рейтинг. Пока оставлю сортировку по кол-ву NFT, как аналог рейтинга, если что напиши - исправлю */
    private func sortUsers() {
        switch currentSortType {
        case .name:
            users.sort { $0.name < $1.name }
        case .rating:
            users.sort { $0.nfts.count > $1.nfts.count }
        }
    }

    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String

        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")

        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
