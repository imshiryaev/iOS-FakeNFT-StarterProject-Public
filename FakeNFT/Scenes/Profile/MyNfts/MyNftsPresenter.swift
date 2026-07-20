import Foundation

// MARK: - Protocol

protocol MyNftsPresenter {
    var itemsCount: Int { get }
    var sortOptions: [MyNftsSortOption] { get }
    func viewDidLoad()
    func item(at index: Int) -> NftListItemViewModel
    func didTapSort()
    func didSelectSort(_ option: MyNftsSortOption)
}

// MARK: - State

enum MyNftsState {
    case initial, loading
    case failed(Error)
    case data
}

final class MyNftsPresenterImpl: MyNftsPresenter {

    // MARK: - Properties

    weak var view: MyNftsView?
    let sortOptions = MyNftsSortOption.allCases

    private let nftIds: [String]
    private let likedIds: Set<String>
    private let loader: NftListLoader
    private let sortStorage: MyNftsSortStorage

    private var nfts: [Nft] = []
    private var authorsById: [String: String] = [:]
    private var items: [NftListItemViewModel] = []

    private var state = MyNftsState.initial {
        didSet {
            stateDidChanged()
        }
    }

    // MARK: - Init

    init(nftIds: [String], likedIds: [String], loader: NftListLoader, sortStorage: MyNftsSortStorage) {
        self.nftIds = nftIds
        self.likedIds = Set(likedIds)
        self.loader = loader
        self.sortStorage = sortStorage
    }

    // MARK: - MyNftsPresenter

    var itemsCount: Int { items.count }

    func viewDidLoad() {
        state = .loading
    }

    func item(at index: Int) -> NftListItemViewModel {
        items[index]
    }

    func didTapSort() {
        view?.showSortOptions()
    }

    func didSelectSort(_ option: MyNftsSortOption) {
        sortStorage.current = option
        rebuildItems()
        view?.reload()
    }

    // MARK: - Private

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            load()
        case .data:
            view?.hideLoading()
            view?.showEmptyState(items.isEmpty)
            view?.reload()
        case .failed(let error):
            view?.hideLoading()
            view?.showError(makeErrorModel(error))
        }
    }

    private func load() {
        loader.load(ids: nftIds) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.nfts = data.nfts
                self.authorsById = data.authorsById
                self.rebuildItems()
                self.state = .data
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }

    private func rebuildItems() {
        let sorted = sort(nfts, by: sortStorage.current)
        items = sorted.map { makeViewModel($0) }
    }

    private func sort(_ nfts: [Nft], by option: MyNftsSortOption) -> [Nft] {
        switch option {
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        case .name:
            return nfts.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }

    private func makeViewModel(_ nft: Nft) -> NftListItemViewModel {
        let authorName = authorsById[nft.author] ?? nft.author
        let authorText = String(format: NSLocalizedString("MyNfts.author", comment: ""), authorName)
        return NftListItemViewModel(
            id: nft.id,
            imageURL: nft.images.first,
            name: nft.name,
            rating: nft.rating,
            priceText: NftPriceFormatter.string(from: nft.price),
            authorText: authorText,
            isLiked: likedIds.contains(nft.id)
        )
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
