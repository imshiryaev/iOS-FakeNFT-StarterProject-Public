import UIKit

protocol NftCollectionViewControllerProtocol: AnyObject, ErrorView, LoadingView {
    func showCollection()
    func reloadData()
    func reloadItem(at index: Int)
    func showLikeLoading(at index: Int)
    func showCartLoading(at index: Int)
    func navigateToDetail(with id: String)
}

private enum Constants {
    static let interitemSpacing: CGFloat = 9
    static let lineSpacing: CGFloat = 20
    static let sectionInset: CGFloat = 16
    static let columns: CGFloat = 3
}

final class NftCollectionViewController: UIViewController, NftCollectionViewControllerProtocol {

    private let presenter: NftCollectionPresenterProtocol
    private let servicesAssembly: ServicesAssembly

    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("NFT.empty", comment: "")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.interitemSpacing
        layout.minimumLineSpacing = Constants.lineSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 20,
            left: Constants.sectionInset,
            bottom: 20,
            right: Constants.sectionInset
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NftCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    init(presenter: NftCollectionPresenterProtocol, servicesAssembly: ServicesAssembly) {
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
        title = NSLocalizedString("Profile.myNfts", comment: "")

        navigationController?.navigationBar.tintColor = .ypBlack
        navigationItem.backButtonDisplayMode = .minimal

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])

        presenter.viewDidLoad()
    }

    func showCollection() {
        collectionView.isHidden = false
        emptyLabel.isHidden = true
    }

    func reloadData() {
        if presenter.numberOfItems == 0 {
            collectionView.isHidden = true
            emptyLabel.isHidden = false
        }
        collectionView.reloadData()
    }

    func reloadItem(at index: Int) {
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }

    func showLikeLoading(at index: Int) {
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? NftCollectionCell
        cell?.showLikeLoading()
    }

    func showCartLoading(at index: Int) {
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? NftCollectionCell
        cell?.showCartLoading()
    }

    func navigateToDetail(with id: String) {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let viewController = assembly.build(with: NftDetailInput(id: id))
        present(viewController, animated: true)
    }
}

extension NftCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NftCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let nft = presenter.nft(at: indexPath.item)
        cell.configure(
            with: nft,
            isLiked: presenter.isLiked(at: indexPath.item),
            isInCart: presenter.isInCart(at: indexPath.item)
        )
        cell.onLikeTapped = { [weak self] in
            self?.presenter.didTapLike(at: indexPath.item)
        }
        cell.onCartTapped = { [weak self] in
            self?.presenter.didTapCart(at: indexPath.item)
        }
        return cell
    }
}

extension NftCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let totalSpacing = Constants.sectionInset * 2 + Constants.interitemSpacing * (Constants.columns - 1)
        let width = (collectionView.bounds.width - totalSpacing) / Constants.columns
        return CGSize(width: width, height: width + 60)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.didSelectItem(at: indexPath.item)
    }
}
