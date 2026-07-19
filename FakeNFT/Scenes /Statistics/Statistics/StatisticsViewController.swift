import UIKit

final class StatisticsViewController: UIViewController, StatisticsView {

    private let presenter: StatisticsPresenterProtocol

    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let paginationIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        return indicator
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.isHidden = true
        return table
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("NFT.empty", comment: "")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var sortBarButtonItem = UIBarButtonItem(
        image: UIImage(resource: .linesHorizontal),
        style: .plain,
        target: self,
        action: #selector(sortButtonTapped)
    )

    init(presenter: StatisticsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()

        navigationItem.backButtonDisplayMode = .minimal

        presenter.viewDidLoad()
    }

    func showTableView() {
        tableView.isHidden = false
        emptyLabel.isHidden = true
    }

    func showEmptyView() {
        tableView.isHidden = true
        emptyLabel.isHidden = false
    }

    func reloadData() {
        tableView.reloadData()
    }

    func showPaginationLoading() {
        paginationIndicator.startAnimating()
        tableView.tableFooterView = paginationIndicator
    }

    func hidePaginationLoading() {
        paginationIndicator.stopAnimating()
        tableView.tableFooterView = nil
    }

    private func setupUI() {

        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = sortBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .systemGray

        view.addSubviews(
            tableView,
            activityIndicator,
            emptyLabel
        )

        tableView.register(StatisticsCell.self)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.horizontalSpacing),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.horizontalSpacing),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: LayoutConstants.horizontalSpacing),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -LayoutConstants.horizontalSpacing)
        ])
    }

    @objc
    private func sortButtonTapped() {

        let alert = UIAlertController(
            title: NSLocalizedString("Sort", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )

        for sortType in StatisticsSortType.allCases {

            let action = UIAlertAction(
                title: sortType.title,
                style: .default
            ) { [weak self] _ in

                self?.presenter.changeSorting(to: sortType)
            }

            alert.addAction(action)
        }

        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Close", comment: ""),
                style: .cancel
            )
        )

        alert.popoverPresentationController?.barButtonItem = sortBarButtonItem

        present(alert, animated: true)
    }
}

extension StatisticsViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        presenter.numberOfUsers
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell: StatisticsCell = tableView.dequeueReusableCell()

        cell.configure(with: presenter.cellViewModel(at: indexPath.row))

        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {

        tableView.bounds.width / LayoutConstants.Statistics.cellAspectRatio
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {

        presenter.loadMoreIfNeeded(index: indexPath.row)
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(at: indexPath, animated: true)

        presenter.didSelectUser(at: indexPath.row)
    }
}
