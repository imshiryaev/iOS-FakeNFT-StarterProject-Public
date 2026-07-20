import UIKit

public final class ProfileAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build(with profileId: String) -> UIViewController {
        let presenter = ProfilePresenterImpl(
            profileId: profileId,
            service: servicesAssembler.profileService
        )
        let viewController = ProfileViewController(presenter: presenter)
        presenter.view = viewController

        let servicesAssembler = servicesAssembler
        viewController.makeEditScreen = { profileId, profile, onProfileUpdated in
            ProfileEditAssembly(servicesAssembler: servicesAssembler)
                .build(with: profileId, profile: profile, onProfileUpdated: onProfileUpdated)
        }
        viewController.makeMyNftsScreen = { nftIds, likedIds in
            MyNftsAssembly(servicesAssembler: servicesAssembler)
                .build(nftIds: nftIds, likedIds: likedIds)
        }
        viewController.makeFavoritesScreen = { profileId, profile, onProfileUpdated in
            FavoritesAssembly(servicesAssembler: servicesAssembler)
                .build(with: profileId, profile: profile, onProfileUpdated: onProfileUpdated)
        }

        return viewController
    }
}
