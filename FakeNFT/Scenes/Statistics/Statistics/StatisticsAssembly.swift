// StatisticsAssembly.swift

import UIKit

final class StatisticsAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build() -> UIViewController {
        let router = StatisticsRouter(servicesAssembler: servicesAssembler)
        let settingsStorage = UserDefaultsSettingsStorage()

        let presenter = StatisticsPresenter(
            userService: servicesAssembler.userService,
            router: router,
            settingsStorage: settingsStorage
        )

        let viewController = StatisticsViewController(presenter: presenter)

        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}
