import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import PhotosUI

struct ProfileTab: View {
    @State private var userName: String = "Loading..."
    @State private var userEmail: String = "Loading..."
    @State private var profileImage: UIImage? = nil
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var calorieGoal: String = ""
    @State private var proteinGoal: String = ""
    @State private var carbsGoal: String = ""
    @State private var fatsGoal: String = ""
    @State private var workoutDays: String = ""

    @State private var showImagePicker = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var showEditProfile = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Profile Picture
                Button(action: { showImagePicker.toggle() }) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.red, lineWidth: 3))
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }
                }
                
                // User Info
                VStack {
                    Text(userName)
                        .font(.title)
                        .bold()
                    Text(userEmail)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Fitness Stats
                VStack(alignment: .leading, spacing: 10) {
                    ProfileRow(title: "Height", value: height)
                    ProfileRow(title: "Weight", value: weight)
                    ProfileRow(title: "Calories Goal", value: calorieGoal)
                    ProfileRow(title: "Protein Goal", value: proteinGoal)
                    ProfileRow(title: "Carbs Goal", value: carbsGoal)
                    ProfileRow(title: "Fats Goal", value: fatsGoal)
                    ProfileRow(title: "Workout Days", value: workoutDays)
                }
                .padding()

                // Edit Profile Button
                Button(action: { showEditProfile.toggle() }) {
                    Text("Edit Profile")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Profile")
            .onAppear { loadUserProfile() }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(
                    height: $height,
                    weight: $weight,
                    calorieGoal: $calorieGoal,
                    proteinGoal: $proteinGoal,
                    carbsGoal: $carbsGoal,
                    fatsGoal: $fatsGoal,
                    workoutDays: $workoutDays,
                    saveProfile: saveProfile
                )
            }
            .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto)
        }
    }

    // Fetch User Info from Firebase
    func loadUserProfile() {
        guard let user = Auth.auth().currentUser else { return }
        userName = user.displayName ?? "No Name"
        userEmail = user.email ?? "No Email"

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        userRef.getDocument { document, error in
            if let data = document?.data() {
                height = data["height"] as? String ?? "Not Set"
                weight = data["weight"] as? String ?? "Not Set"
                calorieGoal = data["caloriesGoal"] as? String ?? "Not Set"
                proteinGoal = data["proteinGoal"] as? String ?? "Not Set"
                carbsGoal = data["carbsGoal"] as? String ?? "Not Set"
                fatsGoal = data["fatsGoal"] as? String ?? "Not Set"
                workoutDays = data["workoutDays"] as? String ?? "Not Set"
            }
        }
    }

    // Save Updated Profile Data
    func saveProfile() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        let updatedData: [String: Any] = [
            "height": height,
            "weight": weight,
            "caloriesGoal": calorieGoal,
            "proteinGoal": proteinGoal,
            "carbsGoal": carbsGoal,
            "fatsGoal": fatsGoal,
            "workoutDays": workoutDays
        ]

        userRef.setData(updatedData, merge: true) { error in
            if let error = error {
                print("❌ Error updating profile: \(error.localizedDescription)")
            } else {
                print("✅ Profile updated successfully!")
            }
        }
    }
}

// Profile Row UI
struct ProfileRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}
