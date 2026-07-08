//
//  PaymentPresenterProtocol.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 08.07.2026.
//

protocol PaymentPresenterProtocol {
    
    var numberOfCurrencies: Int { get }
    
    func viewDidLoad()
    
    func currency(at index: Int) -> PaymentCurrency
    
    func selectCurrency(at index: Int)
    
    func pay()
    
    func isSelected(currency: PaymentCurrency) -> Bool
}
