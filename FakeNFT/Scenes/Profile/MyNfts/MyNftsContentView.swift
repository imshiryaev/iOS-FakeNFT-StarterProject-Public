import UIKit

final class MyNftsContentView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNftsCell.self)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = 140
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let activityIndicator = UIActivityIndicatorView()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.text = NSLocalizedString("MyNfts.empty", comment: "")
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setEmptyState(_ isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    private func setupLayout() {
        addSubview(tableView)
        addSubview(emptyLabel)
        addSubview(activityIndicator)

        tableView.constraintEdges(to: self)
        activityIndicator.constraintCenters(to: self)

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
}
