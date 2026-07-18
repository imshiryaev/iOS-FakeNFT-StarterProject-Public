//
//  UserService.swift
//  FakeNFT
//
import Foundation

// UserService.swift
protocol UserServiceProtocol {
    @discardableResult
    func fetchUsers(
        page: Int,
        size: Int,
        completion: @escaping (Result<(users: [User], fetchedCount: Int), Error>) -> Void
    ) -> NetworkTask?
}

final class UserService: UserServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    @discardableResult
    func fetchUsers(
        page: Int,
        size: Int,
        completion: @escaping (Result<(users: [User], fetchedCount: Int), Error>) -> Void
    ) -> NetworkTask? {
        let userRequest = UserRequest(page: page, size: size)

        return networkClient.send(
            request: userRequest,
            type: [UserDTO].self
        ) { result in
            switch result {
            case .success(let userDTOs):
                let users = userDTOs.compactMap { $0.toDomain() }
                completion(.success((users: users, fetchedCount: userDTOs.count)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
