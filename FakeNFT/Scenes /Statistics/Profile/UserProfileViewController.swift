import UIKit
import Kingfisher

final class UserProfileViewController: UIViewController, UserProfileViewControllerProtocol {

    private let presenter: UserProfilePresenterProtocol
    private let servicesAssembly: ServicesAssembly

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.tintColor = .systemGray
        imageView.backgroundColor = UIColor(hexString: "#F7F7F8")
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.numberOfLines = 2
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.numberOfLines = 0
        return label
    }()

    private lazy var websiteButton: UIButton = {
            let button = UIButton(type: .system)
            button.titleLabel?.font = .caption1
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.setTitle(NSLocalizedString("Profile.website", comment: ""), for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.ypBlack.cgColor
            button.layer.cornerRadius = 12
            button.addTarget(self, action: #selector(websiteTapped), for: .touchUpInside)
            return button
        }()

    private let collectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    }()

    private let collectionChevron: UIImageView = {
            let config = UIImage.SymbolConfiguration(weight: .bold)
            let imageView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: config))
            imageView.tintColor = .textPrimary
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()

    private lazy var collectionControl: UIControl = {
        let control = UIControl()
        control.addTarget(self, action: #selector(collectionTapped), for: .touchUpInside)
        return control
    }()

    init(presenter: UserProfilePresenterProtocol, servicesAssembly: ServicesAssembly) {
        self.presenter = presenter
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.tintColor = .ypBlack
        navigationItem.backButtonDisplayMode = .minimal

        setupUI()
        setupConstraints()
        presenter.viewDidLoad()
    }

    func displayUser(name: String, avatarURL: URL, description: String?, website: URL?, nftsCount: Int) {
        nameLabel.text = name

        let hasDescription = !(description ?? "").isEmpty
        descriptionLabel.text = description
        descriptionLabel.isHidden = !hasDescription

        avatarImageView.kf.setImage(
            with: avatarURL,
            placeholder: UIImage(systemName: "person.circle.fill")
        )

        websiteButton.isHidden = website == nil

        collectionTitleLabel.text = String(format: NSLocalizedString("Profile.collection", comment: ""), nftsCount)
    }

    func openWebView(url: URL) {
        let webViewController = WebViewController(url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }

    func openCollection(nftIDs: [UUID]) {
        let assembly = NftCollectionAssembly(servicesAssembler: servicesAssembly)
        let viewController = assembly.build(with: NftCollectionInput(nftIDs: nftIDs))
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func setupUI() {
        view.addSubviews(
            avatarImageView,
            nameLabel,
            descriptionLabel,
            websiteButton,
            collectionControl
        )
        collectionControl.addSubviews(collectionTitleLabel, collectionChevron)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            websiteButton.heightAnchor.constraint(equalToConstant: 40),

            collectionControl.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 57),
            collectionControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionControl.heightAnchor.constraint(equalToConstant: 44),

            collectionTitleLabel.leadingAnchor.constraint(equalTo: collectionControl.leadingAnchor),
            collectionTitleLabel.centerYAnchor.constraint(equalTo: collectionControl.centerYAnchor),

            collectionChevron.trailingAnchor.constraint(equalTo: collectionControl.trailingAnchor),
            collectionChevron.centerYAnchor.constraint(equalTo: collectionControl.centerYAnchor),
            collectionChevron.widthAnchor.constraint(equalToConstant: 12),
            collectionChevron.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    @objc
    private func websiteTapped() {
        presenter.didTapWebsite()
    }

    @objc
    private func collectionTapped() {
        presenter.didTapCollection()
    }
}
