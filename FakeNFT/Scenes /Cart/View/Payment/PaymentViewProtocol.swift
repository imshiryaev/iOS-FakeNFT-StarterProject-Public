//
//  PaymentViewProtocol.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 08.07.2026.
//

protocol PaymentViewProtocol: AnyObject {
    
    func reloadData()
    
    func updateSelectedCurrency(_ currency: PaymentCurrency)
    
    func showPaymentError()
    
    func showPaymentSuccess()
}
