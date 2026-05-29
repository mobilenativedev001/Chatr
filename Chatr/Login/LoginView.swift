// LoginView.swift
// Chatr Design System — Login Demo
//
// Full sign-in screen built exclusively with Chatr DS components and tokens.
//
// DS Components used:
//   • DSPromoBanner     — promotional strip at the top + inline error banner
//   • DSPageHeader      — screen title / subtitle pair
//   • DSLabel           — caption, divider label, footer text
//   • DSTextField       — email & password fields (configuration-based init)
//   • DSButton          — primary sign-in CTA, ghost forgot-password, outline register
//
// DS Tokens used:
//   • RDSToken.Color.*         — all colours (background, surface, border, brand…)
//   • RDSToken.Typography.*    — all font styles via DSLabel / DSPageHeader
//   • RDSToken.Spacing.*       — small (8), medium (16), large (24) layout gaps

import SwiftUI
import Components
import Tokens

// MARK: - LoginView

struct LoginView: View {

    // MARK: ViewModel

    @StateObject private var viewModel = LoginViewModel(
        authService: MockAuthService(
            behaviour: .delayed(seconds: 1.5, then: .success)
        )
    )

    // MARK: External validation result bindings

    @State private var emailValidation:    DSValidationResult = .idle
    @State private var passwordValidation: DSValidationResult = .idle

    // MARK: Navigation flags

    @State private var showForgotPassword = false
    @State private var showCreateAccount  = false
    @State private var showPrivacyPolicy  = false

    // MARK: Body

    var body: some View {
        ZStack(alignment: .top) {
            RDSToken.Color.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                logoHeaderSection
                // ── Scrollable content ──
                ScrollView(showsIndicators: false) {
                    contentStack
                }
            }
        }
        .navigationBarHidden(true)
        // Mirror server-side failure into field error states
        .onChange(of: viewModel.loginError) { error in
            if error != nil {
                emailValidation    = .invalid(message: "")
                passwordValidation = .invalid(message: "")
            } else {
                emailValidation    = .idle
                passwordValidation = .idle
            }
        }
        // Clear error when user starts correcting inputs
        .onChange(of: viewModel.email)    { _ in viewModel.dismissError() }
        .onChange(of: viewModel.password) { _ in viewModel.dismissError() }
        // Post-login destination
        .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
            if let user = viewModel.loggedInUser {
                MainTabView(user: user)
            }
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
    }
    
    
    private var logoHeaderSection: some View {
        VStack(spacing: RDSToken.Spacing.large) {
            logoSection
                .padding(.top, RDSToken.Spacing.large)
            HStack {
                DSPageHeader(
                    title: "Now you make the call",
                    subtitle: "Sign in to manage your account",
                    titleColor: DSTextColor.inverse,
                    subtitleColor: DSTextColor.inverse
                )
                .padding(.horizontal, RDSToken.Spacing.large)
            }
            .frame(maxWidth:.infinity, alignment: .leading)
            .padding(.bottom, RDSToken.Spacing.large)
        }
        .frame(maxWidth: .infinity)
        .background(RDSToken.Color.brandTextColor)
         
    }

    // MARK: - Promo Banner

    private var promoBannerSection: some View {
        DSPromoBanner(
            configuration: DSPromoBannerConfiguration(
                text: "Sign up today & get 3 months free on select plans",
                iconName: "tag.fill",
                variant: .offer
            )
        )
    }

    // MARK: - Content stack

    private var contentStack: some View {
        VStack(alignment: .center, spacing: 0) {

            // Page heading
            headerSection
                .padding(.top, RDSToken.Spacing.large)
                .padding(.horizontal, RDSToken.Spacing.large)

            // Inline error banner (animates in/out)
            if viewModel.loginError != nil {
                errorBanner
                    .padding(.horizontal, RDSToken.Spacing.large)
                    .padding(.top, RDSToken.Spacing.medium)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.loginError != nil)
            }

            // Email + Password fields
            formSection
                .padding(.top, RDSToken.Spacing.large)
                .padding(.horizontal, RDSToken.Spacing.large)

            // Forgot password — trailing-aligned ghost button
            forgotPasswordRow
                .padding(.top, RDSToken.Spacing.small)
                .padding(.horizontal, RDSToken.Spacing.large)

            // Primary sign-in CTA
            signInButton
                .padding(.top, RDSToken.Spacing.large)
                .padding(.horizontal, RDSToken.Spacing.large)

            // "or" divider
            dividerRow
                .padding(.top, RDSToken.Spacing.large)
                .padding(.horizontal, RDSToken.Spacing.large)

            // Outline "Create account" button
            createAccountButton
                .padding(.top, RDSToken.Spacing.medium)
                .padding(.horizontal, RDSToken.Spacing.large)

            // Privacy policy footer
            footerLinks
                .padding(.top, RDSToken.Spacing.large)
                .padding(.horizontal, RDSToken.Spacing.large)
                .padding(.bottom, 40)
        }
    }

    // MARK: - Logo

    private var logoSection: some View {
        Image("ChatrLogo")
            .resizable()
            .scaledToFit()
            .frame(height: 56)
            .accessibilityLabel("Chatr")
    }

    // MARK: - Header (DSPageHeader)

    private var headerSection: some View {
        DSPageHeader(
            title: "Sign in",
            subtitle: "With your My Chatr credentials"
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Error Banner (DSPromoBanner custom variant)

    @ViewBuilder
    private var errorBanner: some View {
        if let message = viewModel.errorMessage {
            DSPromoBanner(
                configuration: DSPromoBannerConfiguration(
                    text: message,
                    iconName: viewModel.isAccountLocked
                        ? "lock.fill"
                        : "exclamationmark.circle.fill",
                    variant: .custom(
                        background: RDSToken.Color.errorColor,
                        foreground: .white
                    )
                )
            )
            .cornerRadius(8)
        }
    }

    // MARK: - Form (DSTextField)

    private var formSection: some View {
        VStack(alignment: .leading, spacing: RDSToken.Spacing.medium) {
            // Email — uses the built-in .email() configuration factory
            DSTextField(
                configuration: {
                    var c = DSTextFieldConfiguration.email(
                        label: "Email address",
                        placeholder: "you@Chatr.com"
                    )
                    c.helperText              = "Enter your Chatr account email"
                    c.prefixIcon              = Image(systemName: "envelope")
                    c.accessibilityIdentifier = "login_email_field"
                    return c
                }(),
                text: $viewModel.email,
                externalResult: $emailValidation
            )

            // Password — uses the built-in .password() configuration factory
            DSTextField(
                configuration: {
                    var c = DSTextFieldConfiguration.password(
                        label: "Password",
                        placeholder: "Enter your password"
                    )
                    c.prefixIcon              = Image(systemName: "lock")
                    c.accessibilityIdentifier = "login_password_field"
                    return c
                }(),
                text: $viewModel.password,
                externalResult: $passwordValidation
            )
        }
    }

    // MARK: - Forgot Password (DSButton ghost)

    private var forgotPasswordRow: some View {
        HStack {
            Spacer()
            DSButton(
                "Forgot password?",
                variant: .ghost,
                size: .small,
                accessibilityHint: "Opens the password reset sheet"
            ) {
                showForgotPassword = true
            }
            .accessibilityIdentifier("forgot_password_button")
        }
    }

    // MARK: - Sign In CTA (DSButton primary)

    private var signInButton: some View {
        DSButton(
            "Sign in",
            variant: .primary,
            size: .large,
            isLoading: viewModel.isLoading,
            isDisabled: !viewModel.isSignInEnabled || viewModel.isAccountLocked,
            accessibilityLabel: "Sign in to Chatr",
            accessibilityHint: "Authenticates with your Chatr credentials"
        ) {
            Task { await viewModel.signIn() }
        }
        .frame(maxWidth: .infinity)
        .accessibilityIdentifier("sign_in_button")
    }

    // MARK: - "or" Divider (DSLabel)

    private var dividerRow: some View {
        HStack(spacing: RDSToken.Spacing.medium) {
            Rectangle()
                .fill(RDSToken.Color.borderColor)
                .frame(height: 1)
            DSLabel("or", style: RDSToken.Typography.bodySmall, color: .secondary)
            Rectangle()
                .fill(RDSToken.Color.borderColor)
                .frame(height: 1)
        }
    }

    // MARK: - Create Account (DSButton outline)

    private var createAccountButton: some View {
        DSButton(
            "Register",
            variant: .ghost,
            size: .large,
            accessibilityHint: "Opens the account registration flow"
        ) {
            showCreateAccount = true
        }
        .frame(maxWidth: .infinity)
        .accessibilityIdentifier("create_account_button")
    }

    // MARK: - Footer (DSLabel)

    private var footerLinks: some View {
        HStack(spacing: 4) {
            DSLabel(
                "By signing in you agree to our",
                style: RDSToken.Typography.caption,
                color: .secondary,
                alignment: .center
            )
            Button {
                showPrivacyPolicy = true
            } label: {
                DSLabel(
                    "Privacy Policy",
                    style: RDSToken.Typography.caption,
                    color: .brand
                )
            }
            .accessibilityIdentifier("privacy_policy_button")
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    LoginView()
}

#Preview("Dark Mode") {
    LoginView()
        .preferredColorScheme(.dark)
}

#Preview("Error — Invalid Credentials") {
    LoginView()
}

#Preview("Forgot Password Sheet") {
    ForgotPasswordView()
}
