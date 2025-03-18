import SwiftUI

struct MacroCalculatorView: View {
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Male"
    @State private var activityLevel: String = "Moderate"
    @State private var goal: String = "Maintain Weight"
    @State private var calorieGoal: Int = 0
    @State private var proteinGoal: Int = 0
    @State private var carbsGoal: Int = 0
    @State private var fatsGoal: Int = 0

    let activityMultipliers = ["Sedentary": 1.2, "Light": 1.375, "Moderate": 1.55, "Heavy": 1.725]
    let goals = ["Lose Fat", "Maintain Weight", "Gain Muscle"]
    let genders = ["Male", "Female"]

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Macro Calculator")
                    .font(.title)
                    .bold()

                // 📏 User Inputs
                VStack(alignment: .leading) {
                    Text("Weight (lbs):")
                    TextField("Enter weight", text: $weight)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)

                    Text("Height (inches):")
                    TextField("Enter height", text: $height)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)

                    Text("Age:")
                    TextField("Enter age", text: $age)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    Text("Gender:")
                    Picker("Select Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { Text($0) }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Text("Activity Level:")
                    Picker("Select Activity", selection: $activityLevel) {
                        ForEach(activityMultipliers.keys.sorted(), id: \.self) { Text($0) }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Text("Goal:")
                    Picker("Select Goal", selection: $goal) {
                        ForEach(goals, id: \.self) { Text($0) }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()

                // 🔢 Calculate Macros
                Button(action: calculateMacros) {
                    Text("Calculate Macros")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                // 📊 Display Results
                if calorieGoal > 0 {
                    VStack {
                        Text("Recommended Daily Intake:")
                            .font(.headline)
                        Text("Calories: \(calorieGoal)")
                            .font(.title2)
                            .bold()
                        Text("Protein: \(proteinGoal)g")
                        Text("Carbs: \(carbsGoal)g")
                        Text("Fats: \(fatsGoal)g")
                    }
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
    }

    // 🔢 Macro Calculation Logic
    func calculateMacros() {
        guard let weight = Double(weight),
              let height = Double(height),
              let age = Double(age),
              let activityMultiplier = activityMultipliers[activityLevel] else { return }

        let weightKg = weight * 0.453592
        let heightCm = height * 2.54

        // 🏋️ Calculate BMR
        let bmr: Double
        if gender == "Male" {
            bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5
        } else {
            bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161
        }

        // 🔥 Total Daily Energy Expenditure (TDEE)
        var tdee = bmr * activityMultiplier

        // 🏆 Adjust for Goal
        switch goal {
        case "Lose Fat":
            tdee -= 500
        case "Gain Muscle":
            tdee += 250
        default:
            break
        }

        // 🔢 Macro Distribution
        calorieGoal = Int(tdee)
        proteinGoal = Int(weight * 1.0) // 1g per lb of weight
        fatsGoal = Int(0.25 * tdee / 9) // 25% of calories from fat
        carbsGoal = Int((tdee - (Double(proteinGoal) * 4) - (Double(fatsGoal) * 9)) / 4) // Remaining calories from carbs
    }
}
