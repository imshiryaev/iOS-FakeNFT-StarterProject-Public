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
        return viewController
    }
}
