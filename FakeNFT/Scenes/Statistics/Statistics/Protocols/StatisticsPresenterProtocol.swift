import Foundation

protocol StatisticsPresenterProtocol: AnyObject {
    var view: StatisticsView? { get set }
    var numberOfUsers: Int { get }
    var currentSortType: StatisticsSortType { get }

    func viewDidLoad()
    func loadMoreIfNeeded(index: Int)
    func cellViewModel(at index: Int) -> StatisticsCellViewModel
    func didSelectUser(at index: Int)
    func changeSorting(to sortType: StatisticsSortType)
}
