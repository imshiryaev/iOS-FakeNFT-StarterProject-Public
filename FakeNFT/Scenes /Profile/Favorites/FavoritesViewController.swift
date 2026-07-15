import UIKit

protocol FavoritesView: AnyObject, ErrorView, LoadingView {
    func reload()
    func showEmptyState(_ isEmpty: Bool)
}

final class FavoritesViewController: UIViewController {

    private let presenter: FavoritesPresenter
    private let contentView = FavoritesContentView()

    internal var activityIndicator: UIActivityIndicatorView {
        contentView.activityIndicator
    }

    // MARK: - Init

    init(presenter: FavoritesPresenter) {
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
        title = NSLocalizedString("Favorites.title", comment: "")
        navigationItem.largeTitleDisplayMode = .never
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        presenter.viewDidLoad()
    }
}

// MARK: - FavoritesView

extension FavoritesViewController: FavoritesView {
    func reload() {
        contentView.collectionView.reloadData()
    }

    func showEmptyState(_ isEmpty: Bool) {
        contentView.setEmptyState(isEmpty)
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.itemsCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: FavoritesCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: presenter.item(at: indexPath.item))
        cell.onLikeTap = { [weak self] in
            self?.presenter.didTapLike(at: indexPath.item)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let insets: CGFloat = 16 * 2
        let interitemSpacing: CGFloat = 7
        let availableWidth = collectionView.bounds.width - insets - interitemSpacing
        let width = availableWidth / 2
        return CGSize(width: width, height: 80)
    }
}
