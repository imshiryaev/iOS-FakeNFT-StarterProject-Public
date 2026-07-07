//
//  CartMockData.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 05.07.2026.
//

import UIKit

enum CartMockData {
    
    static let nftList: [CartNFT] = [
        CartNFT(id: "1", title: "April", price: 1.7, rating: 1, image: UIImage(resource: .mockNFTPic)),
        CartNFT(id: "2", title: "Greena", price: 1.35, rating: 3, image: UIImage(resource: .mockNFTPic)),
        CartNFT(id: "3", title: "Spring", price: 1.78, rating: 5, image: UIImage(resource: .mockNFTPic))
    ]
}
