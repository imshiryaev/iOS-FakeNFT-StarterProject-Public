import UIKit

final class UserProfileAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build(with input: UserProfileInput) -> UIViewController {
        let presenter = UserProfilePresenter(input: input)
        let viewController = UserProfileViewController(
            presenter: presenter,
            servicesAssembly: servicesAssembler
        )
        presenter.view = viewController
        return viewController
    }
}
