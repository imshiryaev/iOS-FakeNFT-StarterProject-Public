//
//  UserCollectionViewController.swift
//  FakeNFT
//
import UIKit

protocol NFTCollectionViewControllerProtocol: AnyObject {
    
}

final class NFTCollectionViewController: UIViewController, NFTCollectionViewControllerProtocol {

    private let presenter: UserNFTCollectionPresenterProtocol

    init(presenter: UserNFTCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
