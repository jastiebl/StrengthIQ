import SwiftUI

struct AddMealSheet: View {
    @Binding var mealName: String
    @Binding var mealCalories: String
    @Binding var mealProtein: String
    @Binding var mealCarbs: String
    @Binding var mealFats: String
    @Binding var showFoodSearch: Bool
    var addMeal: () -> Void

    var body: some View {
        VStack {
            Text("Add Meal")
                .font(.title)
                .bold()
                .padding()

            // 🔍 Search or Enter Manually
            Button(action: { showFoodSearch = true }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search Food Database")
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()

            Text("OR")
                .font(.headline)
                .padding(.top)

            // 📝 Manual Meal Entry
            VStack {
                TextField("Meal Name", text: $mealName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Calories", text: $mealCalories)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding()

                TextField("Protein (g)", text: $mealProtein)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding()

                TextField("Carbs (g)", text: $mealCarbs)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding()

                TextField("Fats (g)", text: $mealFats)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding()
            }

            Button(action: addMeal) {
                Text("Save Meal")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
}
