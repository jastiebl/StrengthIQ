struct MacroCalculator {
    static func calculateMacros(weight: Double, height: Double, age: Int, gender: String, activityLevel: String, goal: String) -> Macros {
        // Step 1: Calculate BMR (Basal Metabolic Rate)
        let bmr: Double
        if gender == "Male" {
            bmr = 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * Double(age))
        } else {
            bmr = 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * Double(age))
        }

        
        
        // Step 2: Adjust for Activity Level
        let activityMultipliers: [String: Double] = [
            "Sedentary": 1.2, "Light": 1.375, "Moderate": 1.55,
            "Active": 1.725, "Very Active": 1.9
        ]
        let tdee = bmr * (activityMultipliers[activityLevel] ?? 1.2)

        // Step 3: Adjust for Goal
        var calories = tdee
        if goal == "Bulk" {
            calories += 500
        } else if goal == "Cut" {
            calories -= 500
        }

        // Step 4: Macronutrient Distribution
        let protein = Int(weight * 2.2) // 1g per lb
        let fats = Int((calories * 0.25) / 9) // 25% of calories from fat
        let carbs = Int((calories - (Double(protein) * 4 + Double(fats) * 9)) / 4) // Remaining calories from carbs

        return Macros(calories: Int(calories), protein: protein, carbs: carbs, fats: fats)
    }
}
