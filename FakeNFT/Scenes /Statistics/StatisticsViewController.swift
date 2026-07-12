//
//  StatisticsViewController.swift
//  FakeNFT
//
import UIKit

protocol StatisticsViewControllerProtocol: AnyObject {
    var presenter: StatisticsPresenterProtocol { get set }
    func reloadData()
}

final class StatisticsViewController: UIViewController, StatisticsViewControllerProtocol, ErrorView {
    
    var presenter: StatisticsPresenterProtocol
    
    init(presenter: StatisticsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        presenter.viewDidLoad()
    }
    
    func reloadData() {
    }
    
}
