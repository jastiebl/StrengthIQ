import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SignupViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var age: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var gender: String = "Male"
    @Published var activityLevel: String = "Sedentary"
    @Published var selectedGoal: String = "Maintenance"
    
    // Store user's workout plan
    @Published var workoutSchedule: [String: String] = [
        "Monday": "Rest", "Tuesday": "Rest", "Wednesday": "Rest",
        "Thursday": "Rest", "Friday": "Rest", "Saturday": "Rest", "Sunday": "Rest"
    ]
    
    @Published var macros: Macros?
    
    func calculateMacros() {
        guard let weightDouble = Double(weight),
              let heightDouble = Double(height),
              let ageInt = Int(age) else {
            return
        }
        
        let macros = MacroCalculator.calculateMacros(
            weight: weightDouble,
            height: heightDouble,
            age: ageInt,
            gender: gender,
            activityLevel: activityLevel,
            goal: selectedGoal
        )
        
        DispatchQueue.main.async {
            self.macros = macros
        }
    }
    

    func generateWorkoutPlan() -> [String: [String]] {
        var workoutPlan: [String: [String]] = [:]
        
        let upperBody = ["Bench Press", "Pull-ups", "Shoulder Press"]
        let lowerBody = ["Squats", "Deadlifts", "Lunges"]
        let fullBody = ["Burpees", "Kettlebell Swings", "Clean and Press"]
        let cardio = ["Running", "Jump Rope", "Rowing"]
        
        for (day, workoutType) in workoutSchedule {
            switch workoutType {
            case "Upper Body":
                workoutPlan[day] = upperBody
            case "Lower Body":
                workoutPlan[day] = lowerBody
            case "Full Body":
                workoutPlan[day] = fullBody
            case "Cardio":
                workoutPlan[day] = cardio
            case "Custom":
                workoutPlan[day] = ["User-defined Workout"]
            default:
                workoutPlan[day] = ["Rest Day"]
            }
        }
        
        return workoutPlan
    }
}
