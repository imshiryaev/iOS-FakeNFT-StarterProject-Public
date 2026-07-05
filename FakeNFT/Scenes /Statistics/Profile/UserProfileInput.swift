//
//  UserProfilePresenter.swift
//  FakeNFT
//

import Foundation

protocol UserProfilePresenterProtocol {
    var user: User { get }
    func viewDidLoad()
    func didTapCollection()
}

final class UserProfilePresenter: UserProfilePresenterProtocol {

    weak var view: UserProfileViewControllerProtocol?
    let user: User

    // Замыкание для перехода на коллекцию — прокидывается из Assembly,
    // чтобы презентер не знал про UIKit-навигацию
    private let onShowCollection: (UserProfileInput) -> Void

    init(input: UserProfileInput, onShowCollection: @escaping (UserProfileInput) -> Void) {
        self.user = input.user
        self.onShowCollection = onShowCollection
    }

    func viewDidLoad() {
        view?.display(user)
    }

    func didTapCollection() {
        onShowCollection(UserProfileInput(user: user))
    }
}
