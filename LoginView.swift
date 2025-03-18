import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToDashboard = false
    @State private var navigateToSignup = false
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            GymTheme.background.ignoresSafeArea() // ✅ Use new GymTheme background

            VStack(spacing: 20) {
                // ✅ Animated Logo
                Text("StrengthIQ")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(GymTheme.text) // ✅ Use GymTheme text color
                    .shadow(radius: 5)
                    .scaleEffect(1.1)
                    .animation(.easeInOut(duration: 1.0), value: navigateToSignup)

                // ✅ Subtext
                Text("Log in to continue your fitness journey")
                    .foregroundColor(GymTheme.secondaryAccent) // ✅ Blue text for contrast

                // ✅ Input Fields
                CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email, keyboardType: .emailAddress)
                    .background(GymTheme.inputField) // ✅ Dark input background
                CustomTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                    .background(GymTheme.inputField)

                // ✅ Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(GymTheme.accent) // ✅ Error in Red
                        .font(.footnote)
                        .padding(.top, -10)
                        .transition(.opacity)
                }

                // ✅ Login Button
                Button(action: login) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        Text(isLoading ? "Logging in..." : "Log In")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isLoading ? Color.gray : GymTheme.buttonBackground) // ✅ Orange-Red Button
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .animation(.easeInOut(duration: 0.2), value: isLoading)
                }
                .padding(.horizontal)

                // ✅ Signup Button
                Button(action: { withAnimation { navigateToSignup = true } }) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(GymTheme.secondaryAccent) // ✅ Bright Blue
                        .bold()
                        .scaleEffect(navigateToSignup ? 1.1 : 1)
                        .animation(.easeInOut(duration: 0.3), value: navigateToSignup)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $navigateToDashboard) {
            DashboardView()
                .transition(.slide)
        }
        .fullScreenCover(isPresented: $navigateToSignup) {
            SignupView()
                .transition(.slide)
        }
    }

    // ✅ Login Function
    func login() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Fake delay for animation
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    withAnimation { navigateToDashboard = true }
                }
            }
        }
    }
}
