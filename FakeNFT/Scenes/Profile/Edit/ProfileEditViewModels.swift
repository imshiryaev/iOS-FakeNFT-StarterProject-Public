import Foundation

struct ProfileEditFormViewModel {
    let avatarURL: URL?
    let name: String
    let description: String
    let website: String
}

struct ProfileEditForm {
    var name: String
    var description: String
    var website: String
    var avatar: String

    init(profile: Profile) {
        self.name = profile.name
        self.description = profile.description
        self.website = profile.website
        self.avatar = profile.avatar
    }

    func makeDto() -> ProfileDto {
        ProfileDto(name: name, description: description, website: website, avatar: avatar)
    }
}
