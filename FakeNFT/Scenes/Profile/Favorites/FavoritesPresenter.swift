import Foundation

// MARK: - Protocol

protocol FavoritesPresenter {
    var itemsCount: Int { get }
    func viewDidLoad()
    func item(at index: Int) -> NftListItemViewModel
    func didTapLike(at index: Int)
}

// MARK: - State

enum FavoritesState {
    case initial, loading
    case failed(Error)
    case data
}

final class FavoritesPresenterImpl: FavoritesPresenter {

    // MARK: - Properties

    weak var view: FavoritesView?
    var onProfileUpdated: ((Profile) -> Void)?

    private let profileId: String
    private var profile: Profile
    private let loader: NftListLoader
    private let service: ProfileService

    private var likedIds: [String]
    private var nfts: [Nft] = []
    private var authorsById: [String: String] = [:]
    private var items: [NftListItemViewModel] = []

    private var state = FavoritesState.initial {
        didSet {
            stateDidChanged()
        }
    }

    // MARK: - Init

    init(profileId: String, profile: Profile, loader: NftListLoader, service: ProfileService) {
        self.profileId = profileId
        self.profile = profile
        self.likedIds = profile.likes
        self.loader = loader
        self.service = service
    }

    // MARK: - FavoritesPresenter

    var itemsCount: Int { items.count }

    func viewDidLoad() {
        state = .loading
    }

    func item(at index: Int) -> NftListItemViewModel {
        items[index]
    }

    func didTapLike(at index: Int) {
        removeLike(id: nfts[index].id)
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
        loader.load(ids: likedIds) { [weak self] result in
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

    private func removeLike(id: String) {
        let newLikes = likedIds.filter { $0 != id }
        view?.showLoading()
        service.updateLikes(profileId: profileId, profile: profile, likes: newLikes) { [weak self] result in
            guard let self else { return }
            self.view?.hideLoading()
            switch result {
            case .success(let updatedProfile):
                self.profile = updatedProfile
                self.likedIds = newLikes
                self.nfts.removeAll { $0.id == id }
                self.rebuildItems()
                self.view?.reload()
                self.view?.showEmptyState(self.items.isEmpty)
                self.onProfileUpdated?(updatedProfile)
            case .failure(let error):
                self.view?.showError(self.makeRemoveErrorModel(id: id, error))
            }
        }
    }

    private func rebuildItems() {
        items = nfts.map { makeViewModel($0) }
    }

    private func makeViewModel(_ nft: Nft) -> NftListItemViewModel {
        NftListItemViewModel(
            id: nft.id,
            imageURL: nft.images.first,
            name: nft.name,
            rating: nft.rating,
            priceText: NftPriceFormatter.string(from: nft.price),
            authorText: authorsById[nft.author] ?? nft.author,
            isLiked: true
        )
    }

    private func makeErrorModel(_ error: Error) -> ErrorModel {
        ErrorModel(
            message: errorMessage(error),
            actionText: NSLocalizedString("Error.repeat", comment: "")
        ) { [weak self] in
            self?.state = .loading
        }
    }

    private func makeRemoveErrorModel(id: String, _ error: Error) -> ErrorModel {
        ErrorModel(
            message: errorMessage(error),
            actionText: NSLocalizedString("Error.repeat", comment: "")
        ) { [weak self] in
            self?.removeLike(id: id)
        }
    }

    private func errorMessage(_ error: Error) -> String {
        switch error {
        case is NetworkClientError:
            return NSLocalizedString("Error.network", comment: "")
        default:
            return NSLocalizedString("Error.unknown", comment: "")
        }
    }
}
