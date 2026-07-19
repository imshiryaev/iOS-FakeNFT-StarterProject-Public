import Foundation

protocol UserProfileViewControllerProtocol: AnyObject {
    func displayUser(name: String, avatarURL: URL, description: String?, website: URL?, nftsCount: Int)
    func openWebView(url: URL)
    func openCollection(nftIDs: [UUID])
}
