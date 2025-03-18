import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NutritionTab: View {
    @State private var caloriesConsumed: Double = 0
    @State private var proteinConsumed: Double = 0
    @State private var carbsConsumed: Double = 0
    @State private var fatsConsumed: Double = 0
    @State private var meals: [Meal] = []
    @State private var showAddMealSheet = false
    @State private var showFoodSearch = false
    @State private var mealName = ""
    @State private var mealCalories = ""
    @State private var mealProtein = ""
    @State private var mealCarbs = ""
    @State private var mealFats = ""

    let calorieGoal: Double = 2000
    let proteinGoal: Double = 180
    let carbsGoal: Double = 250
    let fatsGoal: Double = 70

    var body: some View {
        ZStack {
            GymTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    
                    // 🏋️‍♂️ Nutrition Rings Section
                    Text("Nutrition Overview")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)

                    HStack(spacing: 20) {
                        NutritionRing(title: "Calories", value: caloriesConsumed, goal: calorieGoal, color: .red)
                        NutritionRing(title: "Protein", value: proteinConsumed, goal: proteinGoal, color: .blue)
                    }
                    
                    HStack(spacing: 20) {
                        NutritionRing(title: "Carbs", value: carbsConsumed, goal: carbsGoal, color: .green)
                        NutritionRing(title: "Fats", value: fatsConsumed, goal: fatsGoal, color: .yellow)
                    }
                    
                    // 🍽️ Meal Log Section
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Today's Meals")
                                .font(.headline)
                                .foregroundColor(GymTheme.text)
                            Spacer()
                            Button(action: { showAddMealSheet.toggle() }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Meal")
                                }
                                .font(.headline)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }

                        // Display Meals
                        if meals.isEmpty {
                            Text("No meals logged yet.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(meals) { meal in
                                MealRow(meal: meal, deleteMeal: deleteMeal)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            loadMealsFromFirestore()
        }
        .sheet(isPresented: $showAddMealSheet) {
            AddMealSheet(
                mealName: $mealName,
                mealCalories: $mealCalories,
                mealProtein: $mealProtein,
                mealCarbs: $mealCarbs,
                mealFats: $mealFats,
                showFoodSearch: $showFoodSearch,
                addMeal: addMeal
            )
        }
        .sheet(isPresented: $showFoodSearch) {
            FoodSearchView { selectedFood in
                self.mealName = selectedFood.name
                self.mealCalories = "\(selectedFood.calories)"
                self.mealProtein = "\(selectedFood.protein)"
                self.mealCarbs = "\(selectedFood.carbs)"
                self.mealFats = "\(selectedFood.fats)"
                self.showAddMealSheet = true
            }
        }
    }

    // ✅ Load meals from Firestore
    func loadMealsFromFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(userID).collection("meals").getDocuments { snapshot, error in
            if let error = error {
                print("🔥 Error loading meals: \(error.localizedDescription)")
                return
            }

            var fetchedMeals: [Meal] = []
            for document in snapshot?.documents ?? [] {
                let data = document.data()
                if let name = data["name"] as? String,
                   let calories = data["calories"] as? Double,
                   let protein = data["protein"] as? Double,
                   let carbs = data["carbs"] as? Double,
                   let fats = data["fats"] as? Double {
                    let meal = Meal(name: name, calories: calories, protein: protein, carbs: carbs, fats: fats)
                    fetchedMeals.append(meal)
                }
            }

            DispatchQueue.main.async {
                self.meals = fetchedMeals
            }
        }
    }

    // ✅ Add a new meal
    func addMeal() {
        guard let calories = Double(mealCalories),
              let protein = Double(mealProtein),
              let carbs = Double(mealCarbs),
              let fats = Double(mealFats),
              !mealName.isEmpty else { return }

        let newMeal = Meal(name: mealName, calories: calories, protein: protein, carbs: carbs, fats: fats)
        meals.append(newMeal)

        caloriesConsumed += calories
        proteinConsumed += protein
        carbsConsumed += carbs
        fatsConsumed += fats

        saveMealToFirestore(meal: newMeal)

        mealName = ""
        mealCalories = ""
        mealProtein = ""
        mealCarbs = ""
        mealFats = ""
        showAddMealSheet = false
    }

    // ✅ Save meal to Firestore
    func saveMealToFirestore(meal: Meal) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(userID).collection("meals").document(meal.id.uuidString).setData([
            "name": meal.name,
            "calories": meal.calories,
            "protein": meal.protein,
            "carbs": meal.carbs,
            "fats": meal.fats
        ]) { error in
            if let error = error {
                print("🔥 Error saving meal: \(error.localizedDescription)")
            } else {
                print("✅ Meal saved successfully!")
            }
        }
    }

    // ✅ Delete a meal
    func deleteMeal(meal: Meal) {
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            caloriesConsumed -= meals[index].calories
            proteinConsumed -= meals[index].protein
            carbsConsumed -= meals[index].carbs
            fatsConsumed -= meals[index].fats
            meals.remove(at: index)
        }
    }
}

// ✅ Nutrition Ring UI Component
struct NutritionRing: View {
    var title: String
    var value: Double
    var goal: Double
    var color: Color

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: min(value / goal, 1.0))
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100, height: 100)

                VStack {
                    Text("\(Int(value))/\(Int(goal))")
                        .font(.caption)
                        .bold()
                    Text(title)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
