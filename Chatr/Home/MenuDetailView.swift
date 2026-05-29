import SwiftUI
import Components
import Tokens

// MARK: - MenuDetailView

struct MenuDetailView: View {

    let menuItem: MenuItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                RDSToken.Color.backgroundColor.ignoresSafeArea()

                DSPageHeader(
                    title: "\(menuItem.rawValue) Details",
                    subtitle: nil
                )
                .multilineTextAlignment(.center)
                .padding(.horizontal, RDSToken.Spacing.large)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(RDSToken.Color.brandTextColor)
                }
            }
        }
    }
}
