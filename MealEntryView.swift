import SwiftUI

struct MealEntryView: View {
    @Binding var mealName: String
    @Binding var mealCalories: String
    @Binding var mealProtein: String
    @Binding var mealCarbs: String
    @Binding var mealFats: String
    var addMeal: () -> Void

    var body: some View {
        VStack {
            CustomTextField(icon: "pencil", placeholder: "Meal Name", text: $mealName)

            CustomTextField(icon: "flame.fill", placeholder: "Calories", text: $mealCalories, keyboardType: .decimalPad)

            CustomTextField(icon: "bolt.fill", placeholder: "Protein", text: $mealProtein, keyboardType: .decimalPad)

            CustomTextField(icon: "leaf.fill", placeholder: "Carbs", text: $mealCarbs, keyboardType: .decimalPad)

            CustomTextField(icon: "drop.fill", placeholder: "Fats", text: $mealFats, keyboardType: .decimalPad)

            Button(action: addMeal) {
                Text("Save Meal")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}
