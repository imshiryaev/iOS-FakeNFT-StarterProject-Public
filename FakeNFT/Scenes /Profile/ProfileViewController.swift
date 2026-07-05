import UIKit
import SafariServices

protocol ProfileView: AnyObject, ErrorView, LoadingView {
    func displayHeader(_ viewModel: ProfileHeaderViewModel)
    func reloadMenu()
    func showTableView()
    func openWebsite(_ url: URL)
    func showEditProfile(profileId: String, profile: Profile)
}

final class ProfileViewController: UIViewController {

    private let presenter: ProfilePresenter
    private let contentView = ProfileContentView()

    var makeEditScreen: ((String, Profile, @escaping (Profile) -> Void) -> UIViewController)?

    internal var activityIndicator: UIActivityIndicatorView {
        contentView.activityIndicator
    }

    // MARK: - Init

    init(presenter: ProfilePresenter) {
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
        let editButton = ActionButton(type: .system)
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .textPrimary
        editButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        editButton.onTap = { [weak self] in
            self?.presenter.didTapEdit()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }

    private func setupBindings() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.onWebsiteTap = { [weak self] in
            self?.presenter.didTapWebsite()
        }
    }
}

// MARK: - ProfileView

extension ProfileViewController: ProfileView {
    func displayHeader(_ viewModel: ProfileHeaderViewModel) {
        contentView.configure(with: viewModel)
    }

    func reloadMenu() {
        contentView.tableView.reloadData()
    }

    func showTableView() {
        contentView.tableView.isHidden = false
    }

    func openWebsite(_ url: URL) {
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true)
    }

    func showEditProfile(profileId: String, profile: Profile) {
        guard let makeEditScreen else { return }
        let editScreen = makeEditScreen(profileId, profile) { [weak self] updatedProfile in
            self?.presenter.didUpdateProfile(updatedProfile)
        }
        present(editScreen, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.menuRows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileMenuCell.reuseIdentifier,
            for: indexPath
        ) as? ProfileMenuCell else {
            return UITableViewCell()
        }
        let row = presenter.menuRows[indexPath.row]
        cell.configure(with: presenter.menuItem(for: row))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = presenter.menuRows[indexPath.row]
        presenter.didSelect(row: row)
    }
}
