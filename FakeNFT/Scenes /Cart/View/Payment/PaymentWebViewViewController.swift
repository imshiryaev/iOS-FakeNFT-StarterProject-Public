//
//  PaymentWebViewViewController.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 09.07.2026.
//

import UIKit
import WebKit

final class PaymentWebViewViewController: UIViewController {
    
    private let url: URL
    
    //MARK: - UI Elements
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .backButton), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        
        navigationItem.leftBarButtonItem = backButton
        
        setupUI()
        loadPage()
    }
    
    //MARK: - init
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Other functions
    
    private func loadPage() {
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}
