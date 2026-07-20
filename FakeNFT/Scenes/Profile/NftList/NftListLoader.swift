import Foundation

struct NftListData {
    let nfts: [Nft]
    let authorsById: [String: String]
}

final class NftListLoader {

    private let nftService: NftService
    private let usersService: UsersService
    private let syncQueue = DispatchQueue(label: "nft-list-loader-queue")

    init(nftService: NftService, usersService: UsersService) {
        self.nftService = nftService
        self.usersService = usersService
    }

    func load(ids: [String], completion: @escaping (Result<NftListData, Error>) -> Void) {
        guard !ids.isEmpty else {
            completion(.success(NftListData(nfts: [], authorsById: [:])))
            return
        }

        let group = DispatchGroup()
        var loadedNfts: [Nft] = []
        var authorsById: [String: String] = [:]
        var failedIds: [String: Error] = [:]
        var usersError: Error?

        group.enter()
        usersService.loadUsers { [syncQueue] result in
            syncQueue.async {
                switch result {
                case .success(let users):
                    users.forEach { authorsById["\($0.id)"] = $0.name }
                case .failure(let error):
                    usersError = error
                }
                group.leave()
            }
        }

        for id in ids {
            group.enter()
            nftService.loadNft(id: id) { [syncQueue] result in
                syncQueue.async {
                    switch result {
                    case .success(let nft):
                        loadedNfts.append(nft)
                    case .failure(let error):
                        failedIds[id] = error
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            let byId = Dictionary(loadedNfts.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
            let ordered = ids.compactMap { byId[$0] }

            if ordered.isEmpty {
                let error = failedIds.values.first ?? usersError ?? NetworkClientError.urlSessionError
                completion(.failure(error))
                return
            }

            completion(.success(NftListData(nfts: ordered, authorsById: authorsById)))
        }
    }
}
