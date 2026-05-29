import SwiftUI
import Components
import Tokens

// MARK: - ShopView

struct ShopView: View {
    var body: some View {
        ZStack {
            RDSToken.Color.backgroundColor.ignoresSafeArea()
            DSPageHeader(
                title: "Shop",
                subtitle: "Browse the latest devices and plans."
            )
            .padding(.horizontal, RDSToken.Spacing.large)
        }
    }
}
