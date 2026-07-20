import Foundation

protocol UserProfilePresenterProtocol: AnyObject {
    var view: UserProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapWebsite()
    func didTapCollection()
}
