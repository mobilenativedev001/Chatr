import Foundation

@MainActor
protocol DashboardViewModelProtocol: ObservableObject {
    var viewData: DashboardViewData { get }

    func didTapAddData()
    func didTapRoamingAction()
    func didTapPromotionAction()
}
