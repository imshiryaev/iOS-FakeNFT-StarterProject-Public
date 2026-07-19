import Foundation

enum StatisticsState {
    case initial
    case loading
    case paginating
    case data
    case empty
    case failed(Error)
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    weak var view: StatisticsView?

    private let userService: UserServiceProtocol
    private let router: StatisticsRouterProtocol
    private let settingsStorage: SettingsStorage

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

    init(
        userService: UserServiceProtocol,
        router: StatisticsRouterProtocol,
        settingsStorage: SettingsStorage
    ) {
        self.userService = userService
        self.router = router
        self.settingsStorage = settingsStorage

        if let savedValue = settingsStorage.string(forKey: sortTypeKey),
           let savedSortType = StatisticsSortType(rawValue: savedValue) {
            currentSortType = savedSortType
        } else {
            currentSortType = .rating
        }
    }

    func viewDidLoad() {
        state = .loading
    }

    func cellViewModel(at index: Int) -> StatisticsCellViewModel {
        let user = users[index]
        return StatisticsCellViewModel(
            position: index + 1,
            name: user.name,
            rating: user.nfts.count,
            avatarURL: user.avatar
        )
    }

    func loadMoreIfNeeded(index: Int) {
        guard index == users.count - 1 else { return }
        loadNextPage()
    }

    func didSelectUser(at index: Int) {
        router.navigateToProfile(with: users[index])
    }

    func changeSorting(to sortType: StatisticsSortType) {
        guard sortType != currentSortType else { return }

        currentSortType = sortType
        settingsStorage.set(sortType.rawValue, forKey: sortTypeKey)

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

        case .paginating:
            view?.showPaginationLoading()

        case .data:
            view?.hideLoading()
            view?.hidePaginationLoading()
            view?.showTableView()
            view?.reloadData()

        case .empty:
            view?.hideLoading()
            view?.hidePaginationLoading()
            view?.showEmptyView()

        case .failed(let error):
            view?.hideLoading()
            view?.hidePaginationLoading()
            view?.showError(makeErrorModel(error))
        }
    }

    private func loadNextPage() {
        guard !isLoadingPage, hasMorePages else { return }

        isLoadingPage = true

        if !users.isEmpty {
            state = .paginating
        }

        currentTask = userService.fetchUsers(page: page, size: size) { [weak self] result in
            guard let self else { return }
            self.isLoadingPage = false

            switch result {
            case .success(let (newUsers, fetchedCount)):
                self.page += 1
                self.hasMorePages = fetchedCount == self.size

                self.users.append(contentsOf: newUsers)
                self.sortUsers()

                self.state = self.users.isEmpty ? .empty : .data

            case .failure(let error):
                if self.users.isEmpty {
                    self.state = .failed(error)
                } else {
                    self.view?.hidePaginationLoading()
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
