//
//  PaymentMockData.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 08.07.2026.
//

import UIKit

enum PaymentMockData {
    
    static let currencies: [PaymentCurrency] = [
        PaymentCurrency(name: "Bitcoin", code: "BTC", image: UIImage(resource: .bitcoinBTC)),
        
        PaymentCurrency(name: "Dogecoin", code: "DOGE", image: UIImage(resource: .dogecoinDOGE)),
        
        PaymentCurrency(name: "Tether", code: "USDT", image: UIImage(resource: .tetherUSDT)),
        
        PaymentCurrency(name: "Apecoin",code: "APE", image: UIImage(resource: .apeCoinAPE)),
        
        PaymentCurrency(name: "Solana",code: "SOL", image: UIImage(resource: .solanaSOL)),
        
        PaymentCurrency(name: "Ethereum", code: "ETH", image: UIImage(resource: .ethereumETH)),
        
        PaymentCurrency(name: "Cardano", code: "ADA", image: UIImage(resource: .cardanoADA)),
        
        PaymentCurrency(name: "Shiba Inu", code: "SHIB", image: UIImage(resource: .shibaInuSHIB))
    ]
}
