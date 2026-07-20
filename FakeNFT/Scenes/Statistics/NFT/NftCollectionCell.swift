import UIKit
import Kingfisher

final class NftCollectionCell: UICollectionViewCell, ReuseIdentifying {

    var onLikeTapped: (() -> Void)?
    var onCartTapped: (() -> Void)?

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = LayoutConstants.NftCollection.imageCornerRadius
        imageView.backgroundColor = .ypLightGray
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        return button
    }()

    private let likeIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = LayoutConstants.NftCollection.ratingSpacing
        return stack
    }()

    private var starViews: [UIImageView] = []

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.numberOfLines = 1
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textSecondary
        return label
    }()

    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        return button
    }()

    private let cartIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private var isLiked = false
    private var isInCart = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        nftImageView.kf.cancelDownloadTask()
        nftImageView.image = nil

        likeIndicator.stopAnimating()
        cartIndicator.stopAnimating()

        likeButton.isHidden = false
        cartButton.isHidden = false

        onLikeTapped = nil
        onCartTapped = nil
    }

    func configure(with nft: Nft, isLiked: Bool, isInCart: Bool) {
        self.isLiked = isLiked
        self.isInCart = isInCart

        nftImageView.kf.setImage(with: nft.images.first)
        nameLabel.text = nft.name
        priceLabel.text = String(format: "%.2f ETH", nft.price)

        updateRating(nft.rating)
        updateLikeIcon()
        updateCartIcon()
    }

    func showLikeLoading() {
        likeButton.isHidden = true
        likeIndicator.startAnimating()
    }

    func showCartLoading() {
        cartButton.isHidden = true
        cartIndicator.startAnimating()
    }

    func hideCartLoading() {
        cartIndicator.stopAnimating()
        cartButton.isHidden = false
    }

    private func updateRating(_ rating: Int) {
        for (index, starView) in starViews.enumerated() {
            starView.tintColor = index < rating
                ? .systemYellow
                : UIColor(hexString: "#E6E6E8")
        }
    }

    private func updateLikeIcon() {
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = isLiked ? .systemRed : .white

        likeIndicator.stopAnimating()
        likeButton.isHidden = false
    }

    private func updateCartIcon() {
        let image = isInCart
            ? UIImage(resource: .cartAdded)
            : UIImage(resource: .cart)

        cartButton.setImage(image, for: .normal)

        cartIndicator.stopAnimating()
        cartButton.isHidden = false
    }

    private func setupUI() {
        for _ in 0..<5 {
            let starView = UIImageView(image: UIImage(systemName: "star.fill"))
            starView.contentMode = .scaleAspectFit

            starViews.append(starView)
            ratingStack.addArrangedSubview(starView)
        }

        contentView.addSubviews(
            nftImageView,
            likeButton,
            likeIndicator,
            ratingStack,
            nameLabel,
            priceLabel,
            cartButton,
            cartIndicator
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),

            likeButton.topAnchor.constraint(
                equalTo: nftImageView.topAnchor,
                constant: LayoutConstants.interItemSpacing8
            ),
            likeButton.trailingAnchor.constraint(
                equalTo: nftImageView.trailingAnchor,
                constant: -LayoutConstants.interItemSpacing8
            ),
            likeButton.widthAnchor.constraint(
                equalToConstant: LayoutConstants.NftCollection.likeButtonSize
            ),
            likeButton.heightAnchor.constraint(
                equalToConstant: LayoutConstants.NftCollection.likeButtonSize
            ),

            likeIndicator.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            likeIndicator.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),

            ratingStack.topAnchor.constraint(
                equalTo: nftImageView.bottomAnchor,
                constant: LayoutConstants.interItemSpacing8
            ),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            nameLabel.topAnchor.constraint(
                equalTo: ratingStack.bottomAnchor,
                constant: LayoutConstants.NftCollection.labelSpacing
            ),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: cartButton.leadingAnchor,
                constant: -LayoutConstants.NftCollection.labelSpacing
            ),

            priceLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: LayoutConstants.NftCollection.labelSpacing
            ),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: cartButton.leadingAnchor,
                constant: -LayoutConstants.NftCollection.labelSpacing
            ),

            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cartButton.widthAnchor.constraint(
                equalToConstant: LayoutConstants.NftCollection.cartButtonSize
            ),
            cartButton.heightAnchor.constraint(
                equalToConstant: LayoutConstants.NftCollection.cartButtonSize
            ),

            cartIndicator.centerXAnchor.constraint(equalTo: cartButton.centerXAnchor),
            cartIndicator.centerYAnchor.constraint(equalTo: cartButton.centerYAnchor)
        ])

        for starView in starViews {
            starView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                starView.widthAnchor.constraint(
                    equalToConstant: LayoutConstants.NftCollection.starSize
                ),
                starView.heightAnchor.constraint(
                    equalToConstant: LayoutConstants.NftCollection.starSize
                )
            ])
        }
    }

    @objc
    private func likeTapped() {
        onLikeTapped?()
    }

    @objc
    private func cartTapped() {
        onCartTapped?()
    }
}
