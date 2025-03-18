import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DashboardView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTab() // ✅ FIX: Ensure no arguments are passed
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            WorkoutTab()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Workouts")
                }
                .tag(1)

            NutritionTab()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Nutrition")
                }
                .tag(2)

            SocialTab()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Social")
                }
                .tag(3)

            ProfileTab()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.red)
    }
}
