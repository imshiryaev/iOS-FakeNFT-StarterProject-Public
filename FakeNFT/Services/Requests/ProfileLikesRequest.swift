import Foundation

struct ProfileLikesRequest: NetworkRequest {
    let id: String
    let name: String
    let description: String
    let website: String
    let avatar: String
    let likes: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?

    var bodyQueryItems: [URLQueryItem]? {
        var items = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "description", value: description),
            URLQueryItem(name: "website", value: website),
            URLQueryItem(name: "avatar", value: avatar)
        ]
        if likes.isEmpty {
            items.append(URLQueryItem(name: "likes", value: ""))
        } else {
            items.append(contentsOf: likes.map { URLQueryItem(name: "likes", value: $0) })
        }
        return items
    }
}
