import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeTab: View {
    @State private var userName: String = "Loading..." // Default placeholder

    var body: some View {
        ZStack {
            GymTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // ✅ Header Section
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome Back,")
                                .font(.title3)
                                .foregroundColor(GymTheme.grayTone)
                            
                            Text(userName) // ✅ Dynamically updates user name
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(GymTheme.text)
                                .transition(.opacity)
                        }
                        Spacer()
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(GymTheme.grayTone)
                    }
                    .padding(.horizontal)
                    .onAppear {
                        fetchUserName()
                    }
                    
                    // ✅ Progress Rings Section
                    HStack(spacing: 40) {
                        ProgressRing(title: "Workout", value: 70, goal: 100, icon: "flame.fill")
                        ProgressRing(title: "Calories", value: 2200, goal: 2500, icon: "leaf.fill")
                    }
                    .frame(height: 150)
                    .transition(.scale)

                    // ✅ Recent Activity Section
                    VStack(alignment: .leading) {
                        Text("Recent Activity")
                            .font(.headline)
                            .foregroundColor(GymTheme.text)
                            .padding(.bottom, 5)
                        
                        RecentActivityCard(title: "Chest Day", subtitle: "Last workout - 2 days ago", icon: "list.bullet.rectangle.portrait.fill")
                        RecentActivityCard(title: "Meal Logged", subtitle: "200g Protein - Yesterday", icon: "fork.knife.circle.fill")
                    }
                    .padding(.horizontal)
                    .transition(.slide)
                    
                    Spacer()
                }
            }
        }
    }

    func fetchUserName() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists, let fetchedName = document.get("name") as? String {
                DispatchQueue.main.async {
                    self.userName = fetchedName
                }
            } else {
                print("⚠️ No 'name' field found in Firestore")
            }
        }
    }
}

// ✅ Fix for Preview Issue
struct HomeTab_Previews: PreviewProvider {
    static var previews: some View {
        HomeTab()
    }
}
