import UIKit
import Kingfisher

final class ProfileEditContentView: UIView {

    // MARK: - Callbacks

    var onChangePhotoTap: (() -> Void)?
    var onNameChanged: ((String) -> Void)?
    var onDescriptionChanged: ((String) -> Void)?
    var onWebsiteChanged: ((String) -> Void)?
    var onSaveTap: (() -> Void)?

    // MARK: - UI

    let activityIndicator = UIActivityIndicatorView(style: .large)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var changePhotoButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .textOnPrimary
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 35
        button.translatesAutoresizingMaskIntoConstraints = false
        button.onTap = { [weak self] in
            self?.onChangePhotoTap?()
        }
        return button
    }()

    private lazy var nameField = makeTextField()
    private lazy var websiteField = makeTextField()

    private lazy var descriptionView: UITextView = {
        let textView = UITextView()
        textView.font = .bodyRegular
        textView.textColor = .textPrimary
        textView.backgroundColor = .segmentInactive
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 12)
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var saveButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.setTitle(NSLocalizedString("ProfileEdit.save", comment: ""), for: .normal)
        button.titleLabel?.font = .bodyBold
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.backgroundColor = .segmentActive
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.onTap = { [weak self] in
            self?.onSaveTap?()
        }
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with viewModel: ProfileEditFormViewModel) {
        nameField.text = viewModel.name
        descriptionView.text = viewModel.description
        websiteField.text = viewModel.website
        updateAvatar(viewModel.avatarURL)
    }

    func updateAvatar(_ url: URL?) {
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "person.crop.circle.fill")
        )
    }

    // MARK: - Private

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentStack)

        let avatarContainer = makeAvatarContainer()
        contentStack.addArrangedSubview(avatarContainer)
        contentStack.addArrangedSubview(makeSection(title: NSLocalizedString("ProfileEdit.name", comment: ""),
                                                    field: nameField))
        contentStack.addArrangedSubview(makeSection(title: NSLocalizedString("ProfileEdit.description", comment: ""),
                                                    field: descriptionView))
        contentStack.addArrangedSubview(makeSection(title: NSLocalizedString("ProfileEdit.website", comment: ""),
                                                    field: websiteField))

        addSubview(saveButton)
        addSubview(activityIndicator)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 22),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -22),

            nameField.heightAnchor.constraint(equalToConstant: 46),
            websiteField.heightAnchor.constraint(equalToConstant: 46),
            descriptionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 132),

            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupActions() {
        nameField.addAction(UIAction { [weak self] _ in
            self?.onNameChanged?(self?.nameField.text ?? "")
        }, for: .editingChanged)

        websiteField.addAction(UIAction { [weak self] _ in
            self?.onWebsiteChanged?(self?.websiteField.text ?? "")
        }, for: .editingChanged)
    }

    private func makeAvatarContainer() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(avatarImageView)
        container.addSubview(changePhotoButton)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: container.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            changePhotoButton.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            changePhotoButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            changePhotoButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            changePhotoButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor)
        ])
        return container
    }

    private func makeSection(title: String, field: UIView) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .headline3
        titleLabel.textColor = .textPrimary

        let section = UIStackView(arrangedSubviews: [titleLabel, field])
        section.axis = .vertical
        section.spacing = 8
        return section
    }

    private func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.font = .bodyRegular
        textField.textColor = .textPrimary
        textField.backgroundColor = .segmentInactive
        textField.layer.cornerRadius = 12
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = padding
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

// MARK: - UITextViewDelegate

extension ProfileEditContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onDescriptionChanged?(textView.text ?? "")
    }
}
