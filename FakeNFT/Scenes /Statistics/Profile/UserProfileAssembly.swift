import UIKit

final class UserProfileAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    // input подключим позже
    func build(with input: UserProfileInput) -> UIViewController {
        let presenter = UserProfilePresenter(input: input)
        let viewController = UserProfileViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
