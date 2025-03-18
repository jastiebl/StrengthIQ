import SwiftUI

struct EditProfileView: View {
    @Binding var height: String
    @Binding var weight: String
    @Binding var calorieGoal: String
    @Binding var proteinGoal: String
    @Binding var carbsGoal: String
    @Binding var fatsGoal: String
    @Binding var workoutDays: String

    var saveProfile: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Edit Profile")
                    .font(.title)
                    .bold()
                    .padding(.top)

                // 📏 Height & Weight
                VStack(alignment: .leading, spacing: 10) {
                    Text("Height:")
                        .font(.headline)
                    TextField("Enter height (ft/in or cm)", text: $height)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Text("Weight:")
                        .font(.headline)
                    TextField("Enter weight (lbs or kg)", text: $weight)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()

                // 🔥 Nutrition Goals
                VStack(alignment: .leading, spacing: 10) {
                    Text("Daily Calorie Goal:")
                        .font(.headline)
                    TextField("Enter calorie goal", text: $calorieGoal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)

                    Text("Protein Goal (g):")
                        .font(.headline)
                    TextField("Enter protein goal", text: $proteinGoal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)

                    Text("Carbs Goal (g):")
                        .font(.headline)
                    TextField("Enter carbs goal", text: $carbsGoal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)

                    Text("Fats Goal (g):")
                        .font(.headline)
                    TextField("Enter fats goal", text: $fatsGoal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding()

                // 💪 Workout Goal
                VStack(alignment: .leading, spacing: 10) {
                    Text("Workout Days Per Week:")
                        .font(.headline)
                    TextField("Enter workout days per week", text: $workoutDays)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding()

                // ✅ Save Button
                Button(action: {
                    saveProfile()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Profile")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}
