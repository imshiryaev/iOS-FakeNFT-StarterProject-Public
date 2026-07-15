//
//  UserService.swift
//  FakeNFT
//
import Foundation

protocol UserServiceProtocol {
    func fetchUsers(page: Int, size: Int, completion: @escaping (Result<[User], Error>) -> Void)
}

final class UserService: UserServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(
        page: Int,
        size: Int,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        let userRequest = UserRequest(page: page, size: size)

        networkClient.send(
            request: userRequest,
            type: [UserDTO].self
        ) { result in
            switch result {
            case .success(let userDTOs):
                let users = userDTOs.compactMap { $0.toDomain() }
                completion(.success(users))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
