//
//  StatisticsPresenter.swift
//  FakeNFT
//

import Foundation

protocol StatisticsPresenterProtocol {
    func viewDidLoad()
    func loadUsers()
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    weak var view: (StatisticsViewControllerProtocol & ErrorView)?
    
    var userService: UserServiceProtocol
    
    private var users: [User] = []
    private var page: Int = 0
    private let size: Int = 15
    private var isLoading = false
    private var hasMorePages = true
    
    var numberOfUsers: Int {
        users.count
    }

    func user(at index: Int) -> User {
        users[index]
    }
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func viewDidLoad() {
        loadUsers()
    }
    
    func loadUsers() {
        
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        
        userService.fetchUsers(page: page, size: size) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false

            switch result {
            case .success(let users):
                self.page += 1
                self.hasMorePages = users.count == self.size
                self.users.append(contentsOf: users)
                self.view?.reloadData()
            case .failure(let error):
                let errorMessage = ErrorModel(message: "Error occured: \(error)", actionText: "Повторить") {
                    self.loadUsers()
                }
                self.view?.showError(errorMessage)
            }
        }
    }
}
