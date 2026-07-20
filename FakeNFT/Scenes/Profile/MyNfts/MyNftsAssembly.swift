import UIKit

public final class MyNftsAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build(nftIds: [String], likedIds: [String]) -> UIViewController {
        let loader = NftListLoader(
            nftService: servicesAssembler.nftService,
            usersService: servicesAssembler.usersService
        )
        let presenter = MyNftsPresenterImpl(
            nftIds: nftIds,
            likedIds: likedIds,
            loader: loader,
            sortStorage: MyNftsSortStorage()
        )
        let viewController = MyNftsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
