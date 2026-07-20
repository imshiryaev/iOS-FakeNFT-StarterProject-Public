import UIKit

protocol StatisticsRouterProtocol: AnyObject {
    func navigateToProfile(with user: User)
}

final class StatisticsRouter: StatisticsRouterProtocol {
    weak var viewController: UIViewController?
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func navigateToProfile(with user: User) {
        let profileViewController = UserProfileAssembly(
            servicesAssembler: servicesAssembler
        ).build(with: UserProfileInput(user: user))

        viewController?.navigationController?.pushViewController(profileViewController, animated: true)
    }
}
