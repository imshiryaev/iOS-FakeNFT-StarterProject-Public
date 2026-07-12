import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNfts(ids: [String], completion: @escaping (Result<[Nft], Error>) -> Void) {
        guard !ids.isEmpty else {
            completion(.success([]))
            return
        }

        let group = DispatchGroup()
        let queue = DispatchQueue(label: "loadNfts.sync")

        var results = [Int: Result<Nft, Error>]()

        for (index, id) in ids.enumerated() {
            group.enter()
            loadNft(id: id) { result in
                queue.async {
                    results[index] = result
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            var nfts: [Nft] = []
            for index in ids.indices {
                switch results[index] {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    completion(.failure(error))
                    return
                case .none:
                    completion(.failure(NetworkClientError.urlSessionError))
                    return
                }
            }
            completion(.success(nfts))
        }
    }
}
