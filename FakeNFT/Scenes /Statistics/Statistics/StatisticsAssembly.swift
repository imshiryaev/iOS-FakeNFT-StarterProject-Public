// StatisticsAssembly.swift

import UIKit

final class StatisticsAssembly {
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    func build() -> UIViewController {
        let presenter = StatisticsPresenter(userService: servicesAssembler.userService)
        
        let viewController = StatisticsViewController(
            presenter: presenter,
            servicesAssembly: servicesAssembler
        )
        
        presenter.view = viewController
        
        return viewController
    }
}
