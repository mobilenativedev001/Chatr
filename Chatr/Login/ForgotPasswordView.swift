import SwiftUI
import Components
import Tokens

// MARK: - ForgotPasswordView (sheet)

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var submitted = false

    var body: some View {
        NavigationView {
            ZStack {
                RDSToken.Color.backgroundColor.ignoresSafeArea()
                VStack(alignment: .leading, spacing: RDSToken.Spacing.large) {
                    DSPageHeader(
                        title: "Reset password",
                        subtitle: "We'll send a reset link to your registered email."
                    )

                    DSTextField(
                        configuration: DSTextFieldConfiguration.email(
                            label: "Email address",
                            placeholder: "you@Chatr.com"
                        ),
                        text: $email
                    )

                    if submitted {
                        DSPromoBanner(
                            configuration: DSPromoBannerConfiguration(
                                text: "Reset link sent — check your inbox.",
                                iconName: "checkmark.circle.fill",
                                variant: .success
                            )
                        )
                        .cornerRadius(8)
                        .transition(.opacity)
                        .animation(.easeIn(duration: 0.3), value: submitted)
                    }

                    DSButton(
                        "Send reset link",
                        variant: .primary,
                        size: .large,
                        isDisabled: email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ) {
                        withAnimation { submitted = true }
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
                .padding(RDSToken.Spacing.large)
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
