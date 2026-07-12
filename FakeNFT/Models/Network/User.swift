//
//  User.swift
//  FakeNFT
//

import Foundation

struct UserDTO: Codable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
    
    func toDomain() -> User? {
        guard
            let avatar = URL(string: avatar),
            let website = URL(string: website),
            let rating = Int(rating),
            let id = UUID(uuidString: id)
        else {
            return nil
        }
        
        let nftIDs = nfts.compactMap(UUID.init(uuidString:))
        guard nftIDs.count == nfts.count else {
            return nil
        }
        
        return User(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nfts: nftIDs,
            rating: rating,
            id: id
        )
    }
}

struct User: Codable {
    let name: String
    let avatar: URL
    let description: String?
    let website: URL?
    let nfts: [UUID]
    let rating: Int
    let id: UUID
}
