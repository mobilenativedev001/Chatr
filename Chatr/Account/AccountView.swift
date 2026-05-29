import SwiftUI
import Components
import Tokens

// MARK: - AccountView

struct AccountView: View {
    var body: some View {
        ZStack {
            RDSToken.Color.backgroundColor.ignoresSafeArea()
            DSPageHeader(
                title: "Account",
                subtitle: "Manage your Chatr account settings."
            )
            .padding(.horizontal, RDSToken.Spacing.large)
        }
    }
}
