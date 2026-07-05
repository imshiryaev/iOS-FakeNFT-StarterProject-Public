import UIKit

final class UserProfilePresenter {
    weak var view: UserProfileViewController?
    private let input: UserProfileInput

    init(input: UserProfileInput) {
        self.input = input
    }
}

// UserProfileViewController.swift — временный минимум
final class UserProfileViewController: UIViewController {
    private let presenter: UserProfilePresenter

    init(presenter: UserProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
