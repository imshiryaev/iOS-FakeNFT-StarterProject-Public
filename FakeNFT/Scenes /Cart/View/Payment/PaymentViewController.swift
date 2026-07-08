//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 07.07.2026.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    private let presenter = PaymentPresenter()
    
    var onPaymentFinished: (() -> Void)?
    
    //MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(PaymentCVCell.self, forCellWithReuseIdentifier: PaymentCVCell.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yaLightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var agreementTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .left
        textView.font = .caption2
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.textPrimary
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(UIColor.textOnPrimary, for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Выберите способ оплаты"
        
        presenter.view = self
        presenter.viewDidLoad()
        
        setupAgreementText()
        setupUI()
    }
    
    //MARK: - init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(bottomView)
        view.addSubview(agreementTextView)
        view.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bottomView.topAnchor.constraint(equalTo: agreementTextView.topAnchor, constant: -16),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            agreementTextView.heightAnchor.constraint(equalToConstant: 44),
            agreementTextView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16),
            agreementTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreementTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func payButtonTapped() {
        presenter.pay()
    }
    
    //MARK: - Other functions
    
    private func setupAgreementText() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let text = NSMutableAttributedString(string: "Совершая покупку, вы соглашаетесь с условиями\n",
                                             attributes: [.foregroundColor: UIColor.textPrimary,
                                                          .paragraphStyle: paragraphStyle])
        
        let linkText = NSAttributedString(string: "Пользовательского соглашения",
                                          attributes: [.link: URL(string: "https://yandex.ru/legal/practicum_termsofuse")!,
                                                       .foregroundColor: UIColor.systemBlue,
                                                       .paragraphStyle: paragraphStyle])
        
        text.append(linkText)
        agreementTextView.attributedText = text
    }
}

//MARK: - CollectionView

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfCurrencies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCVCell.reuseIdentifier, for: indexPath) as! PaymentCVCell
        let currency = presenter.currency(at: indexPath.row)
        let selected = presenter.isSelected(currency: currency)
        
        cell.configure(with: currency)
        cell.setSelected(selected)
        
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectCurrency(at: indexPath.row)
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 7) / 2
        
        return CGSize(width: width, height: 46)
    }
}

//MARK: - Protocol

extension PaymentViewController: PaymentViewProtocol {
    func showPaymentError() {
        let alert = UIAlertController(title: nil, message: "Не удалось произвести оплату", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.presenter.pay()})
        
        present(alert, animated: true)
    }
    
    func showPaymentSuccess() {
        let vc = SuccessfulPaymentViewController()
        
        vc.modalPresentationStyle = .fullScreen
        
        vc.onBackToCart = { [weak self, weak vc] in
            vc?.dismiss(animated: false) {
                self?.navigationController?.popViewController(animated: true)
                self?.onPaymentFinished?()
            }
        }
        present(vc, animated: true)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func updateSelectedCurrency(_ currency: PaymentCurrency) {
        collectionView.reloadData()
    }
}

//MARK: - Для TextView

extension PaymentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        UIApplication.shared.open(url)
        return false
    }
}
