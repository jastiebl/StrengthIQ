import SwiftUI

struct NotificationSettingsView: View {
    var body: some View {
        ZStack {
            GymTheme.background.ignoresSafeArea()
            Text("Notification Settings")
                .foregroundColor(GymTheme.text)
                .font(.largeTitle)
        }
    }
}
