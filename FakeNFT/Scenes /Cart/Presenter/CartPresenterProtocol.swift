//
//  CartPresenterProtocol.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 05.07.2026.
//

import Foundation

protocol CartPresenterProtocol {
    
    var view: CartViewProtocol? { get set }
    var numberOfItems: Int { get }

    func viewDidLoad()
    func nft(at index: Int) -> CartNFT
    func sort(by type: CartSortType)
    func deleteNFT(at index: Int)
    func didTapDelete(at index: Int)
}
