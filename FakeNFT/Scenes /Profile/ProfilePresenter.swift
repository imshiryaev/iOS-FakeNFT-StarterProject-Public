import Foundation

// MARK: - Protocol

protocol ProfilePresenter {
    var menuRows: [ProfileMenuRow] { get }
    func viewDidLoad()
    func menuItem(for row: ProfileMenuRow) -> ProfileMenuItemViewModel
    func didTapWebsite()
    func didTapEdit()
    func didUpdateProfile(_ profile: Profile)
    func didSelect(row: ProfileMenuRow)
}

// MARK: - State

enum ProfileState {
    case initial, loading
    case failed(Error)
    case data(Profile)
}

final class ProfilePresenterImpl: ProfilePresenter {

    // MARK: - Properties

    weak var view: ProfileView?
    let menuRows = ProfileMenuRow.allCases

    private let profileId: String
    private let service: ProfileService
    private var profile: Profile?
    private var state = ProfileState.initial {
        didSet {
            stateDidChanged()
        }
    }

    // MARK: - Init

    init(profileId: String, service: ProfileService) {
        self.profileId = profileId
        self.service = service
    }

    // MARK: - ProfilePresenter

    func viewDidLoad() {
        state = .loading
    }

    func menuItem(for row: ProfileMenuRow) -> ProfileMenuItemViewModel {
        switch row {
        case .myNft:
            return ProfileMenuItemViewModel(
                title: NSLocalizedString("Profile.myNft", comment: ""),
                count: profile?.nfts.count ?? 0
            )
        case .favorites:
            return ProfileMenuItemViewModel(
                title: NSLocalizedString("Profile.favorites", comment: ""),
                count: profile?.likes.count ?? 0
            )
        }
    }

    func didTapWebsite() {
        guard let website = profile?.website, let url = URL(string: website) else { return }
        view?.openWebsite(url)
    }

    func didTapEdit() {
        guard let profile else { return }
        view?.showEditProfile(profileId: profileId, profile: profile)
    }

    func didUpdateProfile(_ profile: Profile) {
        state = .data(profile)
    }

    func didSelect(row: ProfileMenuRow) {
        guard let profile else { return }
        switch row {
        case .myNft:
            view?.showMyNfts(nftIds: profile.nfts, likedIds: profile.likes)
        case .favorites:
            view?.showFavorites(profileId: profileId, profile: profile)
        }
    }

    // MARK: - Private

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadProfile()
        case .data(let profile):
            self.profile = profile
            view?.hideLoading()
            view?.showTableView()
            view?.displayHeader(makeHeaderViewModel(profile))
            view?.reloadMenu()
        case .failed(let error):
            view?.hideLoading()
            view?.showError(makeErrorModel(error))
        }
    }

    private func loadProfile() {
        service.loadProfile(id: profileId) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.state = .data(profile)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func makeHeaderViewModel(_ profile: Profile) -> ProfileHeaderViewModel {
        ProfileHeaderViewModel(
            avatarURL: URL(string: profile.avatar),
            name: profile.name,
            description: profile.description,
            website: profile.website
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
