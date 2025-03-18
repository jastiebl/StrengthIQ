import SwiftUI
import FirebaseAuth

struct AccountSettingsView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @State private var navigateToLogin = false

    var body: some View {
        NavigationView {
            ZStack {
                GymTheme.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Account Settings")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(GymTheme.accent)

                    Form {
                        Section {
                            Button(action: logout) {
                                HStack {
                                    Image(systemName: "arrow.backward.circle.fill")
                                        .foregroundColor(.red)
                                    Text("Log Out")
                                        .foregroundColor(.red)
                                        .bold()
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden) // Keeps dark mode theme
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $navigateToLogin) {
                LoginView() // Navigates back to login screen
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false // Resets login state
            navigateToLogin = true // Redirects to login screen
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
