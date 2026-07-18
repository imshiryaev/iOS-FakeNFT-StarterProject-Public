import Foundation

protocol StatisticsPresenterProtocol: AnyObject {
    var view: StatisticsView? { get set }
    var numberOfUsers: Int { get }
    var currentSortType: StatisticsSortType { get }

    func viewDidLoad()
    func loadMoreIfNeeded(index: Int)
    func user(at index: Int) -> User
    func didSelectUser(at index: Int)
    func changeSorting(to sortType: StatisticsSortType)
}
