import SwiftUI


struct MacroSelectionSheet: View {
    let macros: Macros
    @Binding var selectedGoal: String
    var onSelect: () -> Void // ✅ Add this parameter

    var body: some View {
        VStack {
            Text("Suggested Macros")
                .font(.title)
                .bold()
                .padding()

            VStack {
                Text("Calories: \(macros.calories) kcal")
                Text("Protein: \(macros.protein)g")
                Text("Carbs: \(macros.carbs)g")
                Text("Fats: \(macros.fats)g")
            }
            .font(.headline)
            .padding()

            Picker("Select Plan", selection: $selectedGoal) {
                Text("Maintenance").tag("Maintenance")
                Text("Bulk").tag("Bulk")
                Text("Cut").tag("Cut")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button(action: onSelect) { // ✅ Close the sheet on selection
                Text("Select This Plan")
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
