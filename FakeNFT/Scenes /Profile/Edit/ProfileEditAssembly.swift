import UIKit

public final class ProfileEditAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build(
        with profileId: String,
        profile: Profile,
        onProfileUpdated: @escaping (Profile) -> Void
    ) -> UIViewController {
        let presenter = ProfileEditPresenterImpl(
            profileId: profileId,
            profile: profile,
            service: servicesAssembler.profileService
        )
        presenter.onProfileUpdated = onProfileUpdated
        let viewController = ProfileEditViewController(presenter: presenter)
        presenter.view = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
