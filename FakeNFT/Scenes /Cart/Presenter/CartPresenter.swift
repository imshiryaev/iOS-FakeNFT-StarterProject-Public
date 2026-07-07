//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 05.07.2026.
//

final class CartPresenter: CartPresenterProtocol {
    
    weak var view: CartViewProtocol?
    
    private var cartNFTs = CartMockData.nftList
    private var currentSort: CartSortType = .price
    
    var numberOfItems: Int { cartNFTs.count }
    
    
    //MARK: - Functions
    
    func viewDidLoad() {
        updateView()
    }
    
    func nft(at index: Int) -> CartNFT {
        cartNFTs[index]
    }
    
    func sort(by type: CartSortType) {
        switch type {
        case .price:
            cartNFTs.sort { $0.price < $1.price }
            
        case .rating:
            cartNFTs.sort { $0.rating > $1.rating }
            
        case .title:
            cartNFTs.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
        currentSort = type
        updateView()
    }
    
    func deleteNFT(at index: Int) {
        cartNFTs.remove(at: index)
        updateView()
    }
    
    func didTapDelete(at index: Int) {
        let nft = cartNFTs[index]
        view?.showDeleteScreen(for: nft, index: index)
    }
    
    private func updateView() {
        let total = cartNFTs.reduce(0) { $0 + $1.price }
        
        view?.updateCartInfo(count: cartNFTs.count, totalPrice: total)
        view?.showEmptyState(cartNFTs.isEmpty)
        view?.reloadData()
    }
}
