//
//  PaymentCVCell.swift
//  FakeNFT
//
//  Created by Анастасия Синило on 07.07.2026.
//

import UIKit

final class PaymentCVCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PaymentCVCell"
    
    //MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = UIColor.yaLightGreen
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = UIColor.yaLightGrey
        layer.cornerRadius = 12
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(codeLabel)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            
            codeLabel.heightAnchor.constraint(equalToConstant: 18),
            codeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            codeLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4)
        ])
    }
    
    //MARK: - Other functions
    
    func configure(with currency: PaymentCurrency) {
        imageView.image = currency.image
        nameLabel.text = currency.name
        codeLabel.text = currency.code
    }
    
    func setSelected(_ selected: Bool) {
        layer.borderWidth = selected ? 1 : 0
        layer.borderColor = UIColor.textPrimary.cgColor
    }
}

