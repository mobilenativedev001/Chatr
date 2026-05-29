import SwiftUI
import Components
import Tokens

// MARK: - HomeView

struct HomeView: View {

    let user: AuthUser

    @State private var isMenuOpen       = false
    @State private var activeMenuItem: MenuItem? = nil
    @Environment(\.dismiss) private var dismiss

    init(user: AuthUser) {
        self.user = user
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {

                // ── Background ──────────────────────────────────────────
                RDSToken.Color.backgroundColor.ignoresSafeArea()

                // ── Main content ────────────────────────────────────────
                VStack(alignment: .leading, spacing: 0) {
                    topBar
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: RDSToken.Spacing.large) {
                            Group {
                                CurrentPlanInfoCard(
                                    planName: "Nation-Wide 20GB",
                                    renewsText: "Renews June 14, 2026",
                                    priceText: "$45"
                                )
                            }
                            .padding(.horizontal, RDSToken.Spacing.large)
                            .padding(.top, RDSToken.Spacing.large)
                            .padding(.bottom, RDSToken.Spacing.large)
                            .background(RDSToken.Color.brandTextColor)
                            
                            DSLabel("Data & Usage",    style: RDSToken.Typography.title4,       color: .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, RDSToken.Spacing.large)

                            DashboardView(
                                viewData: DashboardFixtures.standard,
                                onTapAddData: {},
                                onTapRoamingAction: {},
                                onTapPromotionAction: {}
                            )
                            .padding(.horizontal, RDSToken.Spacing.large)
                        }
                    }
                }

                // ── Dim overlay ─────────────────────────────────────────
                if isMenuOpen {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { closeMenu() }
                        .zIndex(1)
                }

                // ── Side drawer ─────────────────────────────────────────
                if isMenuOpen {
                    SideMenuView(
                        user: user,
                        onMenuTap: { item in
                            closeMenu()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                activeMenuItem = item
                            }
                        },
                        onSignOut: {
                            closeMenu()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                dismiss()
                            }
                        }
                    )
                    .frame(width: geo.size.width * 0.78)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
                }
            }
        }
        .sheet(item: $activeMenuItem) { item in
            MenuDetailView(menuItem: item)
        }
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack {
            // TODO: Replace with enterprise icon-button component when available.
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isMenuOpen = true
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            }
            .accessibilityLabel("Open menu")

            Image("ChatrLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 32)
                .padding()

            Spacer()

            // Balance spacer so logo stays centred
            Color.clear.frame(width: 20, height: 20)
        }
        .padding(.horizontal, RDSToken.Spacing.medium)
        .padding(.vertical, RDSToken.Spacing.medium)
        .background(RDSToken.Color.brandTextColor)
    }

    // MARK: - Helpers

    private func closeMenu() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isMenuOpen = false
        }
    }
}

    // MARK: - Previews

    #Preview("Home - Light") {
        HomeView(
            user: AuthUser(
                id: "preview-user-1",
                email: "preview@chatr.com",
                displayName: "Preview User"
            )
        )
    }

    #Preview("Home - Dark") {
        HomeView(
            user: AuthUser(
                id: "preview-user-1",
                email: "preview@chatr.com",
                displayName: "Preview User"
            )
        )
        .preferredColorScheme(.dark)
    }

