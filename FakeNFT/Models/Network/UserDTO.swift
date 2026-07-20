import Foundation


struct UserDTO: Codable {
    /// Имя пользователя.
    let name: String

    /// Ссылка на аватар пользователя.
    let avatar: String

    /// Описание профиля.
    let description: String?

    /// Ссылка на сайт пользователя.
    let website: String

    /// Массив идентификаторов NFT.
    let nfts: [String]

    /// Рейтинг пользователя.
    let rating: String

    /// Идентификатор пользователя.
    let id: String

    func toDomain() -> User? {
        
        // claudflare поменял адрес этих картинок, но сервер отдает старые URL
        let avatarString = avatar.replacingOccurrences(of: "cloudflare-ipfs.com", with: "ipfs.io")

        guard
            let avatar = URL(string: avatarString),
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
