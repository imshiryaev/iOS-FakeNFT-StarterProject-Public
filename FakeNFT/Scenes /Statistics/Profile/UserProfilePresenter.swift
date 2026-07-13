import Foundation

protocol UserProfileProtocol {
    
}

final class UserProfilePresenter: UserProfileProtocol {
    weak var view: UserProfileViewControllerProtocol?
    private let input: UserProfileInput

    init(input: UserProfileInput) {
        self.input = input
    }
}
