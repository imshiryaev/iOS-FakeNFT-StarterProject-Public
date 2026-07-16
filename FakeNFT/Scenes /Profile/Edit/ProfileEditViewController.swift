import UIKit

protocol ProfileEditView: AnyObject, ErrorView, LoadingView {
    func fillForm(_ viewModel: ProfileEditFormViewModel)
    func updateAvatar(_ url: URL?)
    func showPhotoOptions()
    func showAvatarURLInput(currentURL: String)
    func showExitConfirmation()
    func setUserInteractionEnabled(_ enabled: Bool)
    func closeScreen()
}

final class ProfileEditViewController: UIViewController {

    private let presenter: ProfileEditPresenter
    private let contentView = ProfileEditContentView()

    internal var activityIndicator: UIActivityIndicatorView {
        contentView.activityIndicator
    }

    // MARK: - Init

    init(presenter: ProfileEditPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBindings()
        presenter.viewDidLoad()
    }

    // MARK: - Private

    private func setupNavigationBar() {
        let closeButton = ActionButton(type: .system)
        closeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        closeButton.tintColor = .textPrimary
        closeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        closeButton.onTap = { [weak self] in
            self?.presenter.didTapClose()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }

    private func setupBindings() {
        contentView.onChangePhotoTap = { [weak self] in
            self?.presenter.didTapChangePhoto()
        }
        contentView.onNameChanged = { [weak self] name in
            self?.presenter.didChangeName(name)
        }
        contentView.onDescriptionChanged = { [weak self] description in
            self?.presenter.didChangeDescription(description)
        }
        contentView.onWebsiteChanged = { [weak self] website in
            self?.presenter.didChangeWebsite(website)
        }
        contentView.onSaveTap = { [weak self] in
            self?.view.endEditing(true)
            self?.presenter.didTapSave()
        }
    }
}

// MARK: - ProfileEditView

extension ProfileEditViewController: ProfileEditView {
    func fillForm(_ viewModel: ProfileEditFormViewModel) {
        contentView.configure(with: viewModel)
    }

    func updateAvatar(_ url: URL?) {
        contentView.updateAvatar(url)
    }

    func showPhotoOptions() {
        let alert = UIAlertController(
            title: NSLocalizedString("ProfileEdit.photoTitle", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("ProfileEdit.changePhoto", comment: ""),
            style: .default
        ) { [weak self] _ in
            self?.presenter.didSelectChangePhoto()
        })
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("ProfileEdit.deletePhoto", comment: ""),
            style: .destructive
        ) { [weak self] _ in
            self?.presenter.didSelectDeletePhoto()
        })
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("ProfileEdit.cancel", comment: ""),
            style: .cancel
        ))
        present(alert, animated: true)
    }

    func showAvatarURLInput(currentURL: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("ProfileEdit.photoURLTitle", comment: ""),
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "http://www.example.com"
            textField.text = currentURL
            textField.keyboardType = .URL
            textField.autocapitalizationType = .none
        }
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("ProfileEdit.cancel", comment: ""),
            style: .cancel
        ))
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("ProfileEdit.save", comment: ""),
            style: .default
        ) { [weak self, weak alert] _ in
            let text = alert?.textFields?.first?.text ?? ""
            self?.presenter.didEnterAvatarURL(text)
        })
        present(alert, animated: true)
    }

    func showExitConfirmation() {
        let alert = UIAlertController(
            title: NSLocalizedString("ProfileEdit.exitTitle", comment: ""),
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("ProfileEdit.stay", comment: ""),
            style: .cancel
        ))
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("ProfileEdit.exit", comment: ""),
            style: .default
        ) { [weak self] _ in
            self?.presenter.didConfirmExit()
        })
        present(alert, animated: true)
    }

    func setUserInteractionEnabled(_ enabled: Bool) {
        contentView.isUserInteractionEnabled = enabled
    }

    func closeScreen() {
        dismiss(animated: true)
    }
}
