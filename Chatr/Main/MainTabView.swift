import SwiftUI
import Components
import Tokens

// MARK: - AppTab

enum AppTab: String, Hashable {
    case home
    case shop
    case topUp
    case billing
    case account
}

// MARK: - MainTabView

struct MainTabView: View {

    let user: AuthUser

    @State private var selectedTab: AppTab = .home

    private var tabItems: [DSTabBarItem<AppTab>] {
        [
            DSTabBarItem(
                id: .home,
                title: "Home",
                iconName: "house",
                selectedIconName: "house.fill"
            ),
            DSTabBarItem(
                id: .shop,
                title: "Shop",
                iconName: "iphone.gen1",
                selectedIconName: "iphone.gen1"
            ),
            DSTabBarItem(
                id: .topUp,
                title: "Top-up",
                iconName: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90",
                selectedIconName: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90"
            ),
            DSTabBarItem(
                id: .billing,
                title: "Billing",
                iconName: "text.document",
                selectedIconName: "text.document.fill"
            ),
            DSTabBarItem(
                id: .account,
                title: "Account",
                iconName: "person",
                selectedIconName: "person.fill"
            )
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            tabContent
            Spacer(minLength: 0)
            DSTabBar(items: tabItems, selection: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .home:    HomeView(user: user)
        case .shop:    ShopView()
        case .topUp:   TopUpView()
        case .billing: BillingView()
        case .account: AccountView()
        }
    }
}
