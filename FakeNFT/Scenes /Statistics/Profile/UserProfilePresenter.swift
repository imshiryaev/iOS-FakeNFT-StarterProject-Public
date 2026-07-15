import Foundation

protocol UserProfilePresenterProtocol {
    
}

final class UserProfilePresenter: UserProfilePresenterProtocol {
    weak var view: UserProfileViewControllerProtocol?
    private let input: UserProfileInput

    init(input: UserProfileInput) {
        self.input = input
    }
}
