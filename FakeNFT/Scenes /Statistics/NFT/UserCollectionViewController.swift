//
//  UserCollectionViewController.swift
//  FakeNFT
//
import UIKit

final class UserCollectionViewController: UIViewController {

    private let presenter: UserCollectionPresenter

    init(presenter: UserCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class UserCollectionPresenter {
    weak var view: UserCollectionViewController?

    private let input: NftCollectionInput
    private let nftService: NftService

    init(input: NftCollectionInput, nftService: NftService) {
        self.input = input
        self.nftService = nftService
    }
}
