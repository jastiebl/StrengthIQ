import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct WorkoutSessionView: View {
    @Environment(\.presentationMode) var presentationMode // ✅ Back Button
    @State private var workoutLogs: [String: [(reps: Int, weight: Double)]] = [:]
    @State private var userID: String = Auth.auth().currentUser?.uid ?? ""

    var body: some View {
        VStack(spacing: 20) {
            
            // ✅ Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go Back
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
                Text("Workout Session")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            
            // ✅ Show Exercises
            if workoutLogs.isEmpty {
                Text("No exercises logged for today! 🏋️‍♂️")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(workoutLogs.keys.sorted(), id: \.self) { exercise in
                            ExerciseLogView(exerciseName: exercise, workoutLogs: $workoutLogs)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            Spacer()
            
            // ✅ Finish Workout Button
            Button(action: finishWorkout) {
                Text("Finish Workout")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
            .padding(.horizontal)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Dark theme
        .onAppear {
            loadWorkoutLogs() // ✅ Fetch saved workouts on load
        }
    }
    
    // ✅ Finish Workout - Save and Exit
    func finishWorkout() {
        saveWorkoutLogs()
        print("Workout Completed! 🏋️‍♂️")
        presentationMode.wrappedValue.dismiss()
    }
    
    // ✅ Load Exercises for Today
    func loadWorkoutLogs() {
        guard !userID.isEmpty else {
            print("🔥 No user ID found")
            return
        }
        let db = Firestore.firestore()

        db.collection("users").document(userID).collection("workouts").getDocuments { snapshot, error in
            if let error = error {
                print("🔥 Error loading workouts: \(error.localizedDescription)")
                return
            }

            var fetchedLogs: [String: [(reps: Int, weight: Double)]] = [:]

            for document in snapshot?.documents ?? [] {
                let data = document.data()
                let exercise = document.documentID
                let logs = data["logs"] as? [[String: Any]] ?? []
                
                fetchedLogs[exercise] = logs.compactMap { log in
                    guard let reps = log["reps"] as? Int, let weight = log["weight"] as? Double else { return nil }
                    return (reps, weight)
                }
            }
            
            DispatchQueue.main.async {
                self.workoutLogs = fetchedLogs
                print("✅ Loaded workouts: \(self.workoutLogs)") // Debugging
            }
        }
    }
    
    // ✅ Save Logged Exercises
    func saveWorkoutLogs() {
        guard !userID.isEmpty else {
            print("🔥 No user ID found")
            return
        }
        let db = Firestore.firestore()

        for (exercise, logs) in workoutLogs {
            let formattedLogs = logs.map { ["reps": $0.reps, "weight": $0.weight] }

            db.collection("users").document(userID).collection("workouts").document(exercise).setData(["logs": formattedLogs]) { error in
                if let error = error {
                    print("🔥 Error saving workout: \(error.localizedDescription)")
                } else {
                    print("✅ Successfully saved \(exercise) workout")
                }
            }
        }
    }
}

// MARK: - Individual Exercise Logging View
struct ExerciseLogView: View {
    var exerciseName: String
    @Binding var workoutLogs: [String: [(reps: Int, weight: Double)]]

    @State private var reps: String = ""
    @State private var weight: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(exerciseName)
                .font(.headline)
                .foregroundColor(.white)

            HStack {
                CustomTextField(icon: "number", placeholder: "Reps", text: $reps, keyboardType: .numberPad)
                CustomTextField(icon: "scalemass", placeholder: "Weight (lbs)", text: $weight, keyboardType: .decimalPad)

                Button(action: logSet) {
                    Text("Log Set")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
            }
        }
        .padding()
    }

    func logSet() {
        guard let repsInt = Int(reps), let weightDouble = Double(weight) else {
            print("Invalid input")
            return
        }
        workoutLogs[exerciseName, default: []].append((reps: repsInt, weight: weightDouble))
        reps = ""
        weight = ""
    }
}

// MARK: - Preview
struct WorkoutSessionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSessionView()
    }
}
