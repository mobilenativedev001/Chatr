import Foundation

enum DashboardFixtures {

    static let standard = DashboardViewData(
        dataUsage: .init(
            title: "Data Usage",
            percentageText: "63%",
            usageText: "12.6 GB of 20 GB is used",
            progress: 0.63,
            includesBonusAction: true
        ),
        roaming: .init(
            title: "Roaming",
            statusText: "Not Active",
            isActive: false,
            actionTitle: "Activate now"
        ),
        promotion: .init(
            badgeText: "Special Offer for you",
            brandName: "Apple",
            headline: "iPhone 17 Pro Max",
            description: "Save up to $1,000 on any iPhone when you trade in your eligible device.",
            actionTitle: "Shop now"
        )
    )

    static let edgeCase = DashboardViewData(
        dataUsage: .init(
            title: "Data Usage",
            percentageText: "100%",
            usageText: "120 GB of 120 GB is used. Add data to avoid service interruptions this billing cycle.",
            progress: 1.0,
            includesBonusAction: true
        ),
        roaming: .init(
            title: "Roaming",
            statusText: "Active",
            isActive: true,
            actionTitle: "Manage"
        ),
        promotion: .init(
            badgeText: "Limited Time Offer",
            brandName: "Apple",
            headline: "iPhone 17 Pro Max 1TB",
            description: "Get extra trade-in value plus instant savings on select plans.",
            actionTitle: "View deal"
        )
    )
}
