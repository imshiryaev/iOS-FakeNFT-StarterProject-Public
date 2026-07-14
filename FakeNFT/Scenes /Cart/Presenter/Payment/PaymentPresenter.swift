//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 08.07.2026.
//

final class PaymentPresenter: PaymentPresenterProtocol {
    
    weak var view: PaymentViewProtocol?
    
    private var currencies = PaymentMockData.currencies
    
    private(set) var selectedCurrency: PaymentCurrency?
    
    var numberOfCurrencies: Int {
        currencies.count
    }
    
    //MARK: - functions
    
    func viewDidLoad() {
        view?.reloadData()
    }
    
    func currency(at index: Int) -> PaymentCurrency {
        currencies[index]
    }
    
    func selectCurrency(at index: Int) {
        let currency = currencies[index]
        
        selectedCurrency = currency
        
        view?.updateSelectedCurrency(currency)
    }
    
    func pay() {
        guard selectedCurrency != nil else {
            view?.showPaymentError()
            return
        }
        
        let success = Bool.random() //пока временная имитация ответа сервера
        if success {
            view?.showPaymentSuccess()
        } else {
            view?.showPaymentError()
        }
    }
    
    func isSelected(currency: PaymentCurrency) -> Bool {
        selectedCurrency?.code == currency.code
    }
}
