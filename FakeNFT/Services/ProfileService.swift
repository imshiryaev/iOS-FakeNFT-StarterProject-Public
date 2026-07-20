import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(id: String, completion: @escaping ProfileCompletion)
    func updateProfile(id: String, dto: ProfileDto, completion: @escaping ProfileCompletion)
    func updateLikes(profileId: String, profile: Profile, likes: [String], completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(id: String, completion: @escaping ProfileCompletion) {
        let request = ProfileRequest(id: id)
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.applyMockListsIfNeeded(to: profile, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateProfile(id: String, dto: ProfileDto, completion: @escaping ProfileCompletion) {
        let request = ProfilePutRequest(id: id, dto: dto)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile.withMockListsIfEmpty()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateLikes(profileId: String, profile: Profile, likes: [String], completion: @escaping ProfileCompletion) {
        let request = ProfileLikesRequest(
            id: profileId,
            name: profile.name,
            description: profile.description,
            website: profile.website,
            avatar: profile.avatar,
            likes: likes
        )
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile.withMockListsIfEmpty()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func applyMockListsIfNeeded(to profile: Profile, completion: @escaping ProfileCompletion) {
        guard profile.nfts.isEmpty || profile.likes.isEmpty else {
            completion(.success(profile))
            return
        }

        let request = NftsPageRequest(page: 1, size: 20)
        networkClient.send(request: request, type: [Nft].self) { result in
            switch result {
            case .success(let nfts):
                let ids = nfts.map(\.id)
                guard !ids.isEmpty else {
                    completion(.success(profile.withMockListsIfEmpty()))
                    return
                }
                let mockNfts = profile.nfts.isEmpty
                    ? Array(ids.prefix(ProfileMock.myNftsCount))
                    : profile.nfts
                let mockLikes = profile.likes.isEmpty
                    ? Array(ids.prefix(ProfileMock.likesCount))
                    : profile.likes
                completion(.success(Profile(
                    id: profile.id,
                    name: profile.name,
                    avatar: profile.avatar,
                    description: profile.description,
                    website: profile.website,
                    nfts: mockNfts,
                    likes: mockLikes
                )))
            case .failure:
                completion(.success(profile.withMockListsIfEmpty()))
            }
        }
    }
}
