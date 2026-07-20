import UIKit
import Kingfisher

final class ProfileContentView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileMenuCell.self, forCellReuseIdentifier: ProfileMenuCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 54
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()

    let activityIndicator = UIActivityIndicatorView()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var websiteButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.titleLabel?.font = .caption1
        button.setTitleColor(.primary, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var onWebsiteTap: (() -> Void)? {
        didSet {
            websiteButton.onTap = onWebsiteTap
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: ProfileHeaderViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        websiteButton.setTitle(viewModel.website, for: .normal)
        avatarImageView.kf.setImage(
            with: viewModel.avatarURL,
            placeholder: UIImage(systemName: "person.crop.circle.fill")
        )
    }

    private func setupLayout() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(websiteButton)
        addSubview(tableView)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: self)
    }
}

final class ActionButton: UIButton {
    var onTap: (() -> Void)?

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        guard let touch = touch else { return }
        let location = touch.location(in: self)
        if bounds.contains(location) {
            onTap?()
        }
    }
}
