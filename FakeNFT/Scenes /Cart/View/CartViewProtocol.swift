//
//  CartViewProtocol.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 05.07.2026.
//

import Foundation

protocol CartViewProtocol: AnyObject {
    
    func reloadData()
    func updateCartInfo(count: Int, totalPrice: Double)
    func showEmptyState(_ isEmpty: Bool)
    func showDeleteScreen(for nft: CartNFT, index: Int)
}
