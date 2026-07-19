import UIKit

final class NftCollectionAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build(with input: NftCollectionInput) -> UIViewController {
            let presenter = NftCollectionPresenter(
                input: input,
                nftService: servicesAssembler.nftService
            )
            let viewController = NftCollectionViewController(
                presenter: presenter,
                servicesAssembly: servicesAssembler
            )
            presenter.view = viewController
            return viewController
        }
}
