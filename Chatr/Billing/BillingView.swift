import SwiftUI
import Components
import Tokens

// MARK: - BillingView

struct BillingView: View {
    var body: some View {
        ZStack {
            RDSToken.Color.backgroundColor.ignoresSafeArea()
            DSPageHeader(
                title: "Billing",
                subtitle: "View invoices and manage payments."
            )
            .padding(.horizontal, RDSToken.Spacing.large)
        }
    }
}
