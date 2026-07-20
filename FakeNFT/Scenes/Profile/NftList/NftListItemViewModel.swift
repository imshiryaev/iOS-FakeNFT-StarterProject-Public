import Foundation

struct NftListItemViewModel {
    let id: String
    let imageURL: URL?
    let name: String
    let rating: Int
    let priceText: String
    let authorText: String
    let isLiked: Bool
}

enum NftPriceFormatter {
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = " "
        return formatter
    }()

    static func string(from price: Double) -> String {
        let value = formatter.string(from: NSNumber(value: price)) ?? "\(price)"
        return "\(value) ETH"
    }
}
