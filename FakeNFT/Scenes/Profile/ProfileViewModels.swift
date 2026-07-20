import Foundation

struct ProfileHeaderViewModel {
    let avatarURL: URL?
    let name: String
    let description: String
    let website: String
}

struct ProfileMenuItemViewModel {
    let title: String
    let count: Int

    var displayTitle: String {
        "\(title) (\(count))"
    }
}

enum ProfileMenuRow: CaseIterable {
    case myNft
    case favorites
}
