//
//  SuccessfulPaymentViewController.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 09.07.2026.
//

import UIKit

final class SuccessfulPaymentViewController: UIViewController {
    
    var onBackToCart: (() -> Void)?
    
    //MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .successfulPayment)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.text = "Успех! Оплата прошла, поздравляем с покупкой!"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вернуться в корзину", for: .normal)
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.backgroundColor = .textPrimary
        button.titleLabel?.font = .bodyBold
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backToCart), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        
        setupUI()
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(backToCartButton)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 278),
            imageView.widthAnchor.constraint(equalToConstant: 278),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.heightAnchor.constraint(equalToConstant: 56),
            label.widthAnchor.constraint(equalToConstant: 303),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backToCartButton.heightAnchor.constraint(equalToConstant: 60),
            backToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func backToCart() {
        onBackToCart?()
    }
}
