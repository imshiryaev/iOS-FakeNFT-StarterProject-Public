import Foundation

final class UserProfilePresenter: UserProfilePresenterProtocol {
    weak var view: UserProfileViewControllerProtocol?

    private let input: UserProfileInput

    init(input: UserProfileInput) {
        self.input = input
    }

    func viewDidLoad() {
        let user = input.user
        view?.displayUser(
            name: user.name,
            avatarURL: user.avatar,
            description: user.description,
            website: user.website,
            nftsCount: user.nfts.count
        )
    }

    func didTapWebsite() {
        guard let url = input.user.website else { return }
        view?.openWebView(url: url)
    }

    func didTapCollection() {
        view?.openCollection(nftIDs: input.user.nfts)
    }
}
