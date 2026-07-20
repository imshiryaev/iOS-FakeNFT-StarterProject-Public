import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "chart.bar.fill"),
        tag: 2
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileController = ProfileAssembly(
            servicesAssembler: servicesAssembly
        ).build(with: "1")
        let profileNavigationController = UINavigationController(rootViewController: profileController)
        profileNavigationController.tabBarItem = profileTabBarItem

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let catalogNavigationController = UINavigationController(rootViewController: catalogController)
        catalogNavigationController.tabBarItem = catalogTabBarItem

        let statisticsController = StatisticsAssembly(
            servicesAssembler: servicesAssembly
        ).build()
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)
        statisticsNavigationController.tabBarItem = statisticsTabBarItem

        viewControllers = [
            profileNavigationController,
            catalogNavigationController,
            statisticsNavigationController
        ]

        view.backgroundColor = .systemBackground
    }
}
