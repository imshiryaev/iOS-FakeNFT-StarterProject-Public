//
//  UserService.swift
//  FakeNFT
//
import Foundation

protocol UserServiceProtocol {
    func fetchUsers(page: Int, size: Int) -> [User]
}

final class UserService: UserServiceProtocol {
    
    var networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(page: Int, size: Int) -> [User] {
        
        networkClient.send
    }
    
    
}
