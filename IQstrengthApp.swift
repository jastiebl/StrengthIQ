import SwiftUI
import FirebaseCore

@main
struct StrengthIQApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                DashboardView() // Show main dashboard
            } else {
                LoginView() // Redirect to login after logout
            }
        }
    }
}
