//
//  UserService.swift
//  FakeNFT
//
import Foundation

protocol UserServiceProtocol {
    func fetchUsers(page: Int, size: Int, completion: @escaping (Result<[User], Error>) -> Void)
}

final class UserService: UserServiceProtocol {
    
    var networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(page: Int, size: Int, completion: @escaping (Result<[User], any Error>) -> Void) {
        let userRequest = UserRequest(page: page, size: size)
        
        networkClient.send(request: userRequest, type: [User].self, onResponse: completion)
    }
    
    
}
