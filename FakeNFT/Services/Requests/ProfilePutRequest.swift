import Foundation

struct ProfilePutRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

struct ProfileDto: Dto {
    let name: String
    let description: String
    let website: String
    let avatar: String

    func asDictionary() -> [String: String] {
        [
            "name": name,
            "description": description,
            "website": website,
            "avatar": avatar
        ]
    }
}
