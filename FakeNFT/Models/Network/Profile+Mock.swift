import Foundation

enum ProfileMock {
    static let myNftsCount = 8
    static let likesCount = 5

    /// Fallback-uuid, если каталог недоступен (TestCatalog, Postman).
    private static let knownIds = [
        "7773e33c-ec15-4230-a102-92426a3a6d5a",
        "f991a551-3046-4bd6-9ab8-b4f8d6561df7",
        "d30d016c-92a9-48c2-8086-d376d5cbe257"
    ]

    static var nftIds: [String] {
        repeatedIds(count: myNftsCount)
    }

    static var likeIds: [String] {
        repeatedIds(count: likesCount)
    }

    private static func repeatedIds(count: Int) -> [String] {
        guard !knownIds.isEmpty, count > 0 else { return [] }
        return (0..<count).map { knownIds[$0 % knownIds.count] }
    }
}

extension Profile {
    /// Подставляет тестовые списки, если сервер вернул пустые массивы.
    func withMockListsIfEmpty() -> Profile {
        let nfts = nfts.isEmpty ? ProfileMock.nftIds : nfts
        let likes = likes.isEmpty ? ProfileMock.likeIds : likes
        return Profile(
            id: id,
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nfts: nfts,
            likes: likes
        )
    }
}
