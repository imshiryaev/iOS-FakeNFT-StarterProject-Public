import Foundation

protocol UserNFTCollectionPresenterProtocol: AnyObject {
    
}

final class NFTCollectionPresenter: UserNFTCollectionPresenterProtocol {
    weak var view: NFTCollectionViewControllerProtocol?

    private let input: NftCollectionInput
    private let nftService: NftService

    init(input: NftCollectionInput, nftService: NftService) {
        self.input = input
        self.nftService = nftService
    }
}
