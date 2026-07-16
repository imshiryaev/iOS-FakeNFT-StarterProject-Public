import UIKit

protocol MyNftsView: AnyObject, ErrorView, LoadingView {
    func reload()
    func showEmptyState(_ isEmpty: Bool)
    func showSortOptions()
}

final class MyNftsViewController: UIViewController {

    private let presenter: MyNftsPresenter
    private let contentView = MyNftsContentView()

    internal var activityIndicator: UIActivityIndicatorView {
        contentView.activityIndicator
    }

    // MARK: - Init

    init(presenter: MyNftsPresenter) {
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
        title = NSLocalizedString("MyNfts.title", comment: "")
        navigationItem.largeTitleDisplayMode = .never
        setupNavigationBar()
        contentView.tableView.dataSource = self
        presenter.viewDidLoad()
    }

    // MARK: - Private

    private func setupNavigationBar() {
        let sortButton = ActionButton(type: .system)
        sortButton.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        sortButton.tintColor = .textPrimary
        sortButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        sortButton.onTap = { [weak self] in
            self?.presenter.didTapSort()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
}

// MARK: - MyNftsView

extension MyNftsViewController: MyNftsView {
    func reload() {
        contentView.tableView.reloadData()
    }

    func showEmptyState(_ isEmpty: Bool) {
        contentView.setEmptyState(isEmpty)
    }

    func showSortOptions() {
        let alert = UIAlertController(
            title: NSLocalizedString("Sort.title", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        presenter.sortOptions.forEach { option in
            alert.addAction(UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                self?.presenter.didSelectSort(option)
            })
        }
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Sort.close", comment: ""),
            style: .cancel
        ))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MyNftsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.itemsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNftsCell = tableView.dequeueReusableCell()
        cell.configure(with: presenter.item(at: indexPath.row))
        return cell
    }
}
