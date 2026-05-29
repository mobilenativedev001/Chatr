import Foundation

struct DashboardViewData: Equatable {
    var dataUsage: DataUsage
    var roaming: Roaming
    var promotion: Promotion

    struct DataUsage: Equatable {
        var title: String
        var percentageText: String
        var usageText: String
        var progress: Double
        var includesBonusAction: Bool
    }

    struct Roaming: Equatable {
        var title: String
        var statusText: String
        var isActive: Bool
        var actionTitle: String
    }

    struct Promotion: Equatable {
        var badgeText: String
        var brandName: String
        var headline: String
        var description: String
        var actionTitle: String
    }
}
