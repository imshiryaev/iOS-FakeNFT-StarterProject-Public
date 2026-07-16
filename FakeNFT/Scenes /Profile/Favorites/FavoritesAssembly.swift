import UIKit

public final class FavoritesAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build(
        with profileId: String,
        profile: Profile,
        onProfileUpdated: @escaping (Profile) -> Void
    ) -> UIViewController {
        let loader = NftListLoader(
            nftService: servicesAssembler.nftService,
            usersService: servicesAssembler.usersService
        )
        let presenter = FavoritesPresenterImpl(
            profileId: profileId,
            profile: profile,
            loader: loader,
            service: servicesAssembler.profileService
        )
        presenter.onProfileUpdated = onProfileUpdated
        let viewController = FavoritesViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
