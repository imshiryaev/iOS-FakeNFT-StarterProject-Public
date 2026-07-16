import UIKit
import Kingfisher

final class FavoritesCell: UICollectionViewCell, ReuseIdentifying {

    var onLikeTap: (() -> Void)?

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var likeButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .redUniversal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.onTap = { [weak self] in
            self?.onLikeTap?()
        }
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        return label
    }()

    private lazy var ratingView = RatingStackView()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textPrimary
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
        nftImageView.image = nil
        onLikeTap = nil
    }

    func configure(with model: NftListItemViewModel) {
        nftImageView.kf.setImage(with: model.imageURL, placeholder: UIImage(systemName: "photo"))
        nameLabel.text = model.name
        ratingView.setRating(model.rating)
        priceLabel.text = model.priceText
    }

    private func setupLayout() {
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, ratingView, priceLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.alignment = .leading
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(infoStack)

        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),

            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),

            ratingView.heightAnchor.constraint(equalToConstant: 12),

            infoStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            infoStack.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor)
        ])
    }
}
