import UIKit
import Kingfisher

final class StatisticsCell: UITableViewCell, ReuseIdentifying {

    private let indexContainer: UIView = {
        let view = UIView()
        return view
    }()

    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()

    private let userInfoView: UserInfoView = {
        let view = UserInfoView()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userInfoView.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: 4,
            left: 0,
            bottom: 4,
            right: 0
        ))
    }

    func configure(index: Int, user: User) {
        indexLabel.text = "\(index)"
        userInfoView.configure(
            name: user.name,
            avatarURL: user.avatar,
            rating: user.nfts.count
        )
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        indexContainer.addSubviews(indexLabel)
        contentView.addSubviews(indexContainer, userInfoView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            indexContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            indexContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indexContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 27),
            indexContainer.heightAnchor.constraint(equalToConstant: 20),

            indexLabel.leadingAnchor.constraint(equalTo: indexContainer.leadingAnchor),
            indexLabel.trailingAnchor.constraint(equalTo: indexContainer.trailingAnchor),
            indexLabel.centerYAnchor.constraint(equalTo: indexContainer.centerYAnchor),

            userInfoView.leadingAnchor.constraint(equalTo: indexContainer.trailingAnchor, constant: 8),
            userInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userInfoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            userInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

final class UserInfoView: UIView {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.backgroundColor = UIColor(hexString: "#F7F7F8")
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        addSubviews(profileImageView, nameLabel, ratingLabel)

        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(name: String, avatarURL: URL, rating: Int) {
        nameLabel.text = name
        ratingLabel.text = "\(rating)"

        profileImageView.tintColor = .systemGray
        // ссылки битые приходят, по ним не открывается аватар
        profileImageView.kf.setImage(
            with: avatarURL,
            placeholder: UIImage(systemName: "person.circle.fill")
        )
    }
    
    func prepareForReuse() {
        profileImageView.kf.cancelDownloadTask()
        profileImageView.image = nil
    }
 
    private func setupUI() {
        backgroundColor = UIColor(hexString: "#F7F7F8")
        layer.cornerRadius = 12
        clipsToBounds = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingLabel.leadingAnchor, constant: -8),

            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
