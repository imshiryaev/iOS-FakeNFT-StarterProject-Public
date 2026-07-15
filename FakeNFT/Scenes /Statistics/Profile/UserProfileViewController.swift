import UIKit

protocol UserProfileViewControllerProtocol: AnyObject {
    
}

final class UserProfileViewController: UIViewController, UserProfileViewControllerProtocol {
    private let presenter: UserProfilePresenterProtocol

    init(presenter: UserProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
