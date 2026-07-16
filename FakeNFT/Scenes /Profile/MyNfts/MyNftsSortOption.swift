import Foundation

enum MyNftsSortOption: String, CaseIterable {
    case price
    case rating
    case name

    var title: String {
        switch self {
        case .price:
            return NSLocalizedString("Sort.byPrice", comment: "")
        case .rating:
            return NSLocalizedString("Sort.byRating", comment: "")
        case .name:
            return NSLocalizedString("Sort.byName", comment: "")
        }
    }
}

final class MyNftsSortStorage {
    private let key = "myNftsSortOption"
    private let defaults = UserDefaults.standard

    var current: MyNftsSortOption {
        get { MyNftsSortOption(rawValue: defaults.string(forKey: key) ?? "") ?? .rating }
        set { defaults.set(newValue.rawValue, forKey: key) }
    }
}
