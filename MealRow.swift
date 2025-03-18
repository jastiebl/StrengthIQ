import SwiftUI

struct MealRow: View {
    var meal: Meal
    var deleteMeal: (Meal) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(meal.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(meal.calories) kcal - Protein: \(meal.protein)g")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()

            Button(action: { deleteMeal(meal) }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
