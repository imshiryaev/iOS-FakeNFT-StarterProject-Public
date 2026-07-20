import UIKit

final class FavoritesContentView: UIView {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(FavoritesCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    let activityIndicator = UIActivityIndicatorView()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.text = NSLocalizedString("Favorites.empty", comment: "")
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
        collectionView.isHidden = isEmpty
    }

    private func setupLayout() {
        addSubview(collectionView)
        addSubview(emptyLabel)
        addSubview(activityIndicator)

        collectionView.constraintEdges(to: self)
        activityIndicator.constraintCenters(to: self)

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
}
