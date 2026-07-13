import UIKit

protocol UserProfileViewControllerProtocol: AnyObject {
    
}

final class UserProfileViewController: UIViewController, UserProfileViewControllerProtocol {
    private let presenter: UserProfilePresenter

    init(presenter: UserProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
