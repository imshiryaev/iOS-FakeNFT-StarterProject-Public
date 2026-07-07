//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 04.07.2026.
//

import UIKit

final class CartTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CartTableViewCell"
    
    var onDeleteTap: (() -> Void)?
    
    //MARK: - UI Elements
    
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor.textPrimary
        label.text = "Цена"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftPriceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .cartDelete), for: .normal)
        button.tintColor = UIColor.textPrimary
        button.addTarget(
            self,
            action: #selector(deleteButtonTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nftRatingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var starImageViews: [UIImageView] = []
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(nftImageView)
        contentView.addSubview(nftStackView)
        contentView.addSubview(deleteButton)
        
        nftStackView.addArrangedSubview(nftTitleLabel)
        nftStackView.addArrangedSubview(nftRatingStackView)
        nftStackView.addArrangedSubview(nftPriceTitleLabel)
        nftStackView.addArrangedSubview(nftPriceValueLabel)
        
        nftStackView.setCustomSpacing(4, after: nftTitleLabel)
        nftStackView.setCustomSpacing(12, after: nftRatingStackView)
        nftStackView.setCustomSpacing(2, after: nftPriceTitleLabel)
        
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.image = UIImage(resource: .ratingStarNoActive)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 12),
                imageView.heightAnchor.constraint(equalToConstant: 12)
            ])
            
            nftRatingStackView.addArrangedSubview(imageView)
            starImageViews.append(imageView)
        }
        
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nftStackView.heightAnchor.constraint(equalToConstant: 92),
            nftStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftStackView.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor, constant: -16),
            nftStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func deleteButtonTapped() {
        onDeleteTap?()
    }
    
    //MARK: - Other functions
    
    func configure(with nft: CartNFT) {
        
        nftTitleLabel.text = nft.title
        
        if let price = priceFormatter.string(from: NSNumber(value: nft.price)) {
            nftPriceValueLabel.text = "\(price) ETH"
        }
        nftImageView.image = nft.image
        
        configureRating(nft.rating)
    }
    
    private func configureRating(_ rating: Int) {
        for (index, imageView) in starImageViews.enumerated() {
            imageView.image = index < rating
            ? UIImage(resource: .ratingStarActive)
            : UIImage(resource: .ratingStarNoActive)
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
}
