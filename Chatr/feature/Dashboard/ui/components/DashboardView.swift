import SwiftUI
import Tokens
import Combine

struct DashboardView: View {
    let viewData: DashboardViewData
    let onTapAddData: () -> Void
    let onTapRoamingAction: () -> Void
    let onTapPromotionAction: () -> Void

    init(
        viewData: DashboardViewData,
        onTapAddData: @escaping () -> Void = {},
        onTapRoamingAction: @escaping () -> Void = {},
        onTapPromotionAction: @escaping () -> Void = {}
    ) {
        self.viewData = viewData
        self.onTapAddData = onTapAddData
        self.onTapRoamingAction = onTapRoamingAction
        self.onTapPromotionAction = onTapPromotionAction
    }

    var body: some View {
        VStack(spacing: RDSToken.Spacing.medium) {
            usageAndCallsRow
            roamingCard
            promotionCard
        }
    }

    private var usageAndCallsRow: some View {
        HStack(alignment: .top, spacing: 9) {
            dataUsageCard
            callsCard
        }
    }

    private var dataUsageCard: some View {
        VStack(alignment: .leading, spacing: RDSToken.Spacing.medium) {
            HStack(spacing: 8) {
                // TODO: Replace with enterprise icon component when available.
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(red: 0.29, green: 0.29, blue: 0.29))

                Text(viewData.dataUsage.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)

                Spacer(minLength: 0)

                if viewData.dataUsage.includesBonusAction {
                    Button(action: onTapAddData) {
                        Circle()
                            .fill(Color(red: 0.94, green: 0.94, blue: 0.94))
                            .frame(width: 31, height: 31)
                            .overlay {
                                Text("+")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color(red: 0.36, green: 0.36, blue: 0.36))
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Add data")
                }
            }

            Text(viewData.dataUsage.percentageText)
                .font(.system(size: 42, weight: .bold))
                .kerning(-0.3)
                .foregroundStyle(Color(red: 0.35, green: 0.35, blue: 0.35))
                .frame(maxWidth: .infinity, alignment: .center)

            Text(viewData.dataUsage.usageText)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(red: 0.29, green: 0.29, blue: 0.29))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)

            ProgressView(value: min(max(viewData.dataUsage.progress, 0), 1))
                .tint(Color(red: 0.64, green: 0.29, blue: 1.0))
                .scaleEffect(x: 1, y: 1.35, anchor: .center)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 186, alignment: .top)
        .background(cardBackground)
    }

    private var callsCard: some View {
        VStack(alignment: .leading, spacing: RDSToken.Spacing.medium) {
            HStack(spacing: 8) {
                // TODO: Replace with enterprise icon component when available.
                Image(systemName: "phone")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.black)

                Text("Calls")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)
            }

            Text("100%")
                .font(.system(size: 42, weight: .bold))
                .kerning(-0.3)
                .foregroundStyle(Color(red: 0.35, green: 0.35, blue: 0.35))
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(spacing: 2) {
                Text("Unlimited")
                    .font(.system(size: 14, weight: .bold))
                Text("Canada wide calls & Texts")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(Color(red: 0.29, green: 0.29, blue: 0.29))
            .frame(maxWidth: .infinity, alignment: .center)

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 186, alignment: .top)
        .background(cardBackground)
    }

    private var roamingCard: some View {
        VStack(spacing: RDSToken.Spacing.medium) {
            HStack(spacing: 8) {
                // TODO: Replace with enterprise icon component when available.
                Image(systemName: "airplane")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)

                VStack(alignment: .leading, spacing: 0) {
                    Text(viewData.roaming.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                    Text(viewData.roaming.statusText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(viewData.roaming.isActive ? .green : .red)
                }

                Spacer(minLength: 0)

                Button(action: onTapRoamingAction) {
                    Text(viewData.roaming.actionTitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(red: 0.33, green: 0.13, blue: 0.54))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 22)
                        .overlay {
                            Capsule()
                                .stroke(Color(red: 0.36, green: 0.16, blue: 0.58), lineWidth: 2)
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 21)
        .frame(maxWidth: .infinity, minHeight: 91, alignment: .leading)
        .background(cardBackground)
    }

    private var promotionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                // TODO: Replace with enterprise icon component when available.
                Image(systemName: "tag.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)

                Text(viewData.promotion.badgeText)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 8)
            .frame(width: 244, height: 33, alignment: .leading)
            .background(Color(red: 0.33, green: 0.13, blue: 0.54))

            HStack(alignment: .top, spacing: 10) {
                Image("iphone_17") // Asset name as a string
                    .resizable()        // Must be called FIRST to allow resizing
                    .scaledToFit()     // Maintains aspect ratio
                    .frame(width: 147, height: 147)

                VStack(alignment: .leading, spacing: 0) {
                    Text(viewData.promotion.brandName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(red: 0.21, green: 0.21, blue: 0.21))
                        .padding(.bottom, 24)

                    Text(viewData.promotion.headline)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(red: 0.21, green: 0.21, blue: 0.21))
                        .padding(.bottom, 24)

                    Text(viewData.promotion.description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(red: 0.21, green: 0.21, blue: 0.21))
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                }
            }

            Button(action: onTapPromotionAction) {
                Text(viewData.promotion.actionTitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(red: 0.33, green: 0.13, blue: 0.54))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 22)
                    .overlay {
                        Capsule()
                            .stroke(Color(red: 0.36, green: 0.16, blue: 0.58), lineWidth: 2)
                    }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 286, alignment: .topLeading)
        .background(cardBackground)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1)
            }
    }
}

private struct DashboardViewModelPreviewAdapter<ViewModel: DashboardViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        DashboardView(
            viewData: viewModel.viewData,
            onTapAddData: viewModel.didTapAddData,
            onTapRoamingAction: viewModel.didTapRoamingAction,
            onTapPromotionAction: viewModel.didTapPromotionAction
        )
    }
}

@MainActor
private final class DashboardPreviewViewModel: DashboardViewModelProtocol {
    @Published var viewData: DashboardViewData

    init(viewData: DashboardViewData) {
        self.viewData = viewData
    }

    func didTapAddData() {}
    func didTapRoamingAction() {}
    func didTapPromotionAction() {}
}

#Preview("Dashboard - Standard") {
    ScrollView {
        DashboardView(
            viewData: DashboardFixtures.standard
        )
        .padding(RDSToken.Spacing.medium)
    }
    .background(RDSToken.Color.backgroundColor)
}

#Preview("Dashboard - Edge") {
    ScrollView {
        DashboardView(
            viewData: DashboardFixtures.edgeCase
        )
        .padding(RDSToken.Spacing.medium)
    }
    .background(RDSToken.Color.backgroundColor)
}

#Preview("Dashboard - Injected ViewModel") {
    ScrollView {
        DashboardViewModelPreviewAdapter(
            viewModel: DashboardPreviewViewModel(viewData: DashboardFixtures.standard)
        )
        .padding(RDSToken.Spacing.medium)
    }
    .background(RDSToken.Color.backgroundColor)
}

#Preview("Dashboard - Dark") {
    ScrollView {
        DashboardView(
            viewData: DashboardFixtures.standard
        )
        .padding(RDSToken.Spacing.medium)
    }
    .background(RDSToken.Color.backgroundColor)
    .preferredColorScheme(.dark)
}
