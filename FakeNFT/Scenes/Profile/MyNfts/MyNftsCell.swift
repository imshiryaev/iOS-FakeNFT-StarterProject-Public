import UIKit
import Kingfisher

final class MyNftsCell: UITableViewCell, ReuseIdentifying {

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var ratingView = RatingStackView()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.text = NSLocalizedString("MyNfts.price", comment: "")
        label.textAlignment = .right
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.numberOfLines = 1
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
        nftImageView.image = nil
    }

    func configure(with model: NftListItemViewModel) {
        nftImageView.kf.setImage(with: model.imageURL, placeholder: UIImage(systemName: "photo"))
        nameLabel.text = model.name
        ratingView.setRating(model.rating)
        authorLabel.text = model.authorText
        priceLabel.text = model.priceText
        likeImageView.tintColor = model.isLiked ? .redUniversal : .white
    }

    private func setupLayout() {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(nftImageView)
        imageContainer.addSubview(likeImageView)

        let infoStack = UIStackView(arrangedSubviews: [nameLabel, ratingView, authorLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.alignment = .leading
        infoStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        infoStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let priceStack = UIStackView(arrangedSubviews: [priceTitleLabel, priceLabel])
        priceStack.axis = .vertical
        priceStack.spacing = 2
        priceStack.alignment = .trailing
        priceStack.setContentHuggingPriority(.required, for: .horizontal)
        priceStack.setContentCompressionResistancePriority(.required, for: .horizontal)

        let rowStack = UIStackView(arrangedSubviews: [imageContainer, infoStack, priceStack])
        rowStack.axis = .horizontal
        rowStack.spacing = 20
        rowStack.alignment = .center
        rowStack.distribution = .fill
        rowStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(rowStack)

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),

            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeImageView.widthAnchor.constraint(equalToConstant: 32),
            likeImageView.heightAnchor.constraint(equalToConstant: 32),

            ratingView.heightAnchor.constraint(equalToConstant: 12),

            rowStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rowStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rowStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            rowStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
