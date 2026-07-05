import UIKit

final class NftCollectionAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build(with input: NftCollectionInput) -> UIViewController {
        let presenter = UserCollectionPresenter(
            input: input,
            nftService: servicesAssembler.nftService
        )
        let viewController = UserCollectionViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
