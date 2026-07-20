import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Dto? { get }
    // Позволяет отправлять повторяющиеся ключи (например, likes=1&likes=2), чего не умеет Dto.
    var bodyQueryItems: [URLQueryItem]? { get }
}

protocol Dto {
    func asDictionary() -> [String: String]
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var bodyQueryItems: [URLQueryItem]? { nil }
}
