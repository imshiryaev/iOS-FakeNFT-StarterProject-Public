import Foundation

protocol StatisticsView: AnyObject, ErrorView, LoadingView {
    func showTableView()
    func showEmptyView()
    func reloadData()
    func navigateToProfile(with user: User)
}
