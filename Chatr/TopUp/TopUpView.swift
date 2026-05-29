import SwiftUI
import Components
import Tokens

// MARK: - TopUpView

struct TopUpView: View {
    var body: some View {
        ZStack {
            RDSToken.Color.backgroundColor.ignoresSafeArea()
            DSPageHeader(
                title: "Top-up",
                subtitle: "Add balance or data to your plan."
            )
            .padding(.horizontal, RDSToken.Spacing.large)
        }
    }
}
