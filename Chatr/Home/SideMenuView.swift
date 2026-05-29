import SwiftUI
import Components
import Tokens

// MARK: - SideMenuView

struct SideMenuView: View {

    let user: AuthUser
    let onMenuTap: (MenuItem) -> Void
    let onSignOut: () -> Void

    var body: some View {
        ZStack {
            RDSToken.Color.buttonPrimaryBackgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // ── User profile header ──────────────────────────────
                    profileHeader
                        .padding(.top, 56)
                        .padding(.horizontal, RDSToken.Spacing.large)
                        .padding(.bottom, RDSToken.Spacing.large)

                    Divider()
                        .background(RDSToken.Color.borderColor)

                    // ── Menu items ───────────────────────────────────────
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(MenuItem.allCases) { item in
                            menuRow(for: item)
                        }
                    }
                    .padding(.top, RDSToken.Spacing.small)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: - Profile header

    private var profileHeader: some View {
        HStack(alignment: .top, spacing: RDSToken.Spacing.medium) {
            ZStack {
                Circle()
                    .fill(RDSToken.Color.brandTextColor.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: "person")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(RDSToken.Color.inverseTextColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                DSHeroText(user.displayName)
                DSLabel(
                    user.email,
                    style: RDSToken.Typography.bodySmall,
                    color: .inverse
                )
            }
        }
    }

    // MARK: - Menu row

    @ViewBuilder
    private func menuRow(for item: MenuItem) -> some View {
        Button {
            if item == .signOut {
                onSignOut()
            } else {
                onMenuTap(item)
            }
        } label: {
            HStack(spacing: RDSToken.Spacing.medium) {
                Image(systemName: item.iconName)
                    .font(.system(size: 18))
                    .foregroundColor(RDSToken.Color.inverseTextColor
                    )
                    .frame(width: 24)

                DSLabel(
                    item.rawValue,
                    style: RDSToken.Typography.bodyRegular,
                    color: .inverse
                )

                Spacer()
            }
            .padding(.horizontal, RDSToken.Spacing.large)
            .padding(.vertical, RDSToken.Spacing.medium)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)

        if item != MenuItem.allCases.last {
            Divider()
                .background(RDSToken.Color.borderColor)
                .padding(.leading, RDSToken.Spacing.large + 24 + CGFloat(RDSToken.Spacing.medium))
        }
    }
}

// MARK: - Preview

#Preview("Side Menu") {
    SideMenuView(
        user: AuthUser(
            id: "preview-user-001",
            email: "alex.taylor@chatr.ca",
            displayName: "Alex Taylor"
        ),
        onMenuTap: { _ in },
        onSignOut: {}
    )
    .frame(width: 320)
}

#Preview("Side Menu Dark") {
    SideMenuView(
        user: AuthUser(
            id: "preview-user-002",
            email: "jamie.lee@chatr.ca",
            displayName: "Jamie Lee"
        ),
        onMenuTap: { _ in },
        onSignOut: {}
    )
    .frame(width: 320)
    .preferredColorScheme(.dark)
}
