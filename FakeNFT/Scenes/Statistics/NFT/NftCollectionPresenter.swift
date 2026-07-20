import Foundation

enum NftCollectionState {
    case initial
    case loading
    case data([Nft])
    case failed(Error)
}

protocol NftCollectionPresenterProtocol: AnyObject {
    var view: NftCollectionViewControllerProtocol? { get set }
    var numberOfItems: Int { get }
    func viewDidLoad()
    func nft(at index: Int) -> Nft
    func isLiked(at index: Int) -> Bool
    func isInCart(at index: Int) -> Bool
    func didTapLike(at index: Int)
    func didTapCart(at index: Int)
    func didSelectItem(at index: Int)
}

final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    weak var view: NftCollectionViewControllerProtocol?

    private let input: NftCollectionInput
    private let nftService: NftService

    private var nfts: [Nft] = []
    private var likedIDs: Set<String> = []
    private var cartIDs: Set<String> = []

    private var state: NftCollectionState = .initial {
        didSet {
            stateDidChanged()
        }
    }

    var numberOfItems: Int {
        nfts.count
    }

    init(input: NftCollectionInput, nftService: NftService) {
        self.input = input
        self.nftService = nftService
    }

    func viewDidLoad() {
        state = .loading
    }

    func nft(at index: Int) -> Nft {
        nfts[index]
    }

    func isLiked(at index: Int) -> Bool {
        likedIDs.contains(nfts[index].id)
    }

    func isInCart(at index: Int) -> Bool {
        cartIDs.contains(nfts[index].id)
    }

    func didTapLike(at index: Int) {
        let id = nfts[index].id
        view?.showLikeLoading(at: index)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            if self.likedIDs.contains(id) {
                self.likedIDs.remove(id)
            } else {
                self.likedIDs.insert(id)
            }
            self.view?.reloadItem(at: index)
        }
    }

    func didTapCart(at index: Int) {
        let id = nfts[index].id
        view?.showCartLoading(at: index)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            if self.cartIDs.contains(id) {
                self.cartIDs.remove(id)
            } else {
                self.cartIDs.insert(id)
            }
            self.view?.reloadItem(at: index)
        }
    }

    func didSelectItem(at index: Int) {
        view?.navigateToDetail(with: nfts[index].id)
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNfts()
        case .data:
            view?.hideLoading()
            view?.showCollection()
            view?.reloadData()
        case .failed(let error):
            view?.hideLoading()
            view?.showError(makeErrorModel(error))
        }
    }

    private func loadNfts() {
        guard !input.nftIDs.isEmpty else {
            nfts = []
            state = .data(nfts)
            return
        }

        let ids = input.nftIDs.map { $0.uuidString.lowercased() }
        nftService.loadNfts(ids: ids) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = nfts
                self.state = .data(nfts)
            case .failure(let error):
                self.state = .failed(error)
            }
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
