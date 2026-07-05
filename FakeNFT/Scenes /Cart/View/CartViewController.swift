//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 04.07.2026.
//

import UIKit

final class CartViewController: UIViewController {
    
    private let servicesAssembly: ServicesAssembly
    
    private var cartNFTs = CartMockData.nftList
    
    private var currentSort: CartSortType = .price
    
    //MARK: - UI Elements
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(resource: .sortBarItem),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped))
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yaLightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "0 NFT"
        label.font = UIFont.caption1
        label.textColor = UIColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00 ETH"
        label.font = UIFont.bodyBold
        label.textColor = UIColor.yaLightGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateInfo()
    }
    
    //MARK: - init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(bottomView)
        view.addSubview(emptyCartLabel)
        
        bottomView.addSubview(countLabel)
        bottomView.addSubview(totalLabel)
        bottomView.addSubview(payButton)
        
        navigationItem.rightBarButtonItem = filterButton
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.heightAnchor.constraint(equalToConstant: 76),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            countLabel.heightAnchor.constraint(equalToConstant: 20),
            countLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            countLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            totalLabel.heightAnchor.constraint(equalToConstant: 22),
            totalLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 2),
            totalLabel.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor),
            totalLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            
            payButton.heightAnchor.constraint(equalToConstant: 44),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            
            emptyCartLabel.heightAnchor.constraint(equalToConstant: 22),
            emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func filterButtonTapped() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
            self.sort(by: .price)}
        )
        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.sort(by: .rating)}
        )
        alert.addAction(UIAlertAction( title: "По названию", style: .default) { _ in
            self.sort(by: .title)}
        )
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func payButtonTapped() {
        print("Оплата")
    }
    
    //MARK: - Other Functions
    
    private func updateInfo() {
        let isEmpty = cartNFTs.isEmpty
        
        emptyCartLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        bottomView.isHidden = isEmpty
        
        navigationItem.rightBarButtonItem = isEmpty ? nil : filterButton
        
        guard !isEmpty else { return }
        
        countLabel.text = "\(cartNFTs.count) NFT"
        
        let totalPrice = cartNFTs.reduce(0) { $0 + $1.price }
        
        if let total = priceFormatter.string(from: NSNumber(value: totalPrice)) {
            totalLabel.text = "\(total) ETH"
        }
    }
    
    private let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    private func sort(by type: CartSortType) {
        switch type {
        case .price:
            cartNFTs.sort { $0.price < $1.price }
            
        case .rating:
            cartNFTs.sort { $0.rating > $1.rating }
            
        case .title:
            cartNFTs.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
        
        currentSort = type
        tableView.reloadData()
    }
    
    private func showDeleteScreen(for index: Int) {
        let nft = cartNFTs[index]
        
        let vc = DeleteViewController(nft: nft)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        vc.onDelete = { [weak self] in
            self?.deleteNFT(at: index)
        }
        
        present(vc, animated: true)
    }
    
    private func deleteNFT(at index: Int) {
        cartNFTs.remove(at: index)
        
        updateInfo()
        tableView.reloadData()
    }
}

//MARK: - TableView

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartNFTs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        let nft = cartNFTs[indexPath.row]
        
        cell.configure(with: nft)
        cell.onDeleteTap = { [weak self] in
            self?.showDeleteScreen(for: indexPath.row)
        }
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
