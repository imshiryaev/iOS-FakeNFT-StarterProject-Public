import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "chart.bar.fill"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

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
            catalogNavigationController,
            statisticsNavigationController
        ]

        view.backgroundColor = .systemBackground
    }
}
