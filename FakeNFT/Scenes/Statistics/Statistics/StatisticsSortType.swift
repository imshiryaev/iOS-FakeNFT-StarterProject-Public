// StatisticsSortType.swift

import Foundation

enum StatisticsSortType: String, CaseIterable {
    case name
    case rating

    var title: String {
        switch self {
        case .name:
            return NSLocalizedString("Sort.byName", comment: "")
        case .rating:
            return NSLocalizedString("Sort.byRating", comment: "")
        }
    }
}
