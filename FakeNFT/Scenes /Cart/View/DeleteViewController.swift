//
//  DeleteViewController.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 05.07.2026.
//

import UIKit

final class DeleteViewController: UIViewController {
    
    private let nft: CartNFT
    
    var onDelete: (() -> Void)?
    
    //MARK: - UI Elements
    
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemThinMaterialLight)
        let blur = UIVisualEffectView(effect: effect)
        blur.translatesAutoresizingMaskIntoConstraints = false
        return blur
    }()
    
    private lazy var nftImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var nftTitle: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.titleLabel?.font = .bodyRegular
        button.tintColor = .yaRed
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться", for: .normal)
        button.titleLabel?.font = .bodyRegular
        button.tintColor = .textOnPrimary
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
        setupUI()
        nftImage.image = nft.image
    }
    
    //MARK: - init
    
    init(nft: CartNFT) {
        self.nft = nft
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(blurView)
        view.addSubview(nftImage)
        view.addSubview(nftTitle)
        view.addSubview(stackButton)
        
        stackButton.addArrangedSubview(deleteButton)
        stackButton.addArrangedSubview(backButton)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            nftImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            nftImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nftTitle.heightAnchor.constraint(equalToConstant: 36),
            nftTitle.widthAnchor.constraint(equalToConstant: 180),
            nftTitle.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 12),
            nftTitle.centerXAnchor.constraint(equalTo: nftImage.centerXAnchor),
            
            stackButton.heightAnchor.constraint(equalToConstant: 44),
            stackButton.widthAnchor.constraint(equalToConstant: 262),
            stackButton.topAnchor.constraint(equalTo: nftTitle.bottomAnchor, constant: 20),
            stackButton.centerXAnchor.constraint(equalTo: nftImage.centerXAnchor),
        ])
    }
    
    //MARK: - Actions
    
    @objc private func deleteButtonTapped() {
        onDelete?()
        dismiss(animated: true)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}
