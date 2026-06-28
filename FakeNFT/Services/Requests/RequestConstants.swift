import Foundation

enum RequestConstants {
    static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
    static let token = Bundle.main.object(forInfoDictionaryKey: "TOKEN") as? String ?? ""
}
