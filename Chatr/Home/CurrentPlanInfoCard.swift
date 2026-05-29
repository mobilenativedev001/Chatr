import SwiftUI
import Tokens

// MARK: - CurrentPlanInfoCard

struct CurrentPlanInfoCard: View {

    let title: String
    let planName: String
    let renewsText: String
    let priceText: String
    let billingCycleText: String

    init(
        title: String = "Active Plan",
        planName: String,
        renewsText: String,
        priceText: String,
        billingCycleText: String = "/month"
    ) {
        self.title = title
        self.planName = planName
        self.renewsText = renewsText
        self.priceText = priceText
        self.billingCycleText = billingCycleText
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            leftContent
                .frame(maxWidth: .infinity)
            Divider()
                .frame(width: 1, height: 80)
                .overlay(Color(red: 0.92, green: 0.92, blue: 0.92))
                .padding(.horizontal, 10)
            rightContent
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 19, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 19, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
    }

    private var leftContent: some View {
        VStack(alignment: .leading, spacing: 23) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(red: 0.01, green: 0.01, blue: 0.01))

            VStack(alignment: .leading, spacing: 4) {
                Text(planName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.black)

                Text(renewsText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(red: 0.41, green: 0.41, blue: 0.41))
            }
        }
    }

    private var rightContent: some View {
        VStack(spacing: 0) {
            Text(priceText)
                .font(.system(size: 42, weight: .bold))
                .kerning(-0.3)
                .foregroundStyle(.black)

            Text(billingCycleText)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(red: 0.34, green: 0.33, blue: 0.33))
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        RDSToken.Color.backgroundColor.ignoresSafeArea()

        CurrentPlanInfoCard(
            planName: "Nation-Wide 20GB",
            renewsText: "Renews June 14, 2026",
            priceText: "$45"
        )
        .padding(.horizontal, RDSToken.Spacing.medium)
    }
}
