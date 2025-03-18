import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutViewModel

    @State private var exercise = ""
    @State private var sets = ""
    @State private var reps = ""
    @State private var weight = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise")) {
                    TextField("Exercise Name", text: $exercise)
                }
                Section(header: Text("Details")) {
                    TextField("Sets", text: $sets)
                        .keyboardType(.numberPad)
                    TextField("Reps", text: $reps)
                        .keyboardType(.numberPad)
                    TextField("Weight (lbs)", text: $weight)
                        .keyboardType(.numberPad)
                }
                Button(action: saveWorkout) {
                    Text("Save Workout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .navigationTitle("Log Workout")
            .toolbar {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    func saveWorkout() {
        guard let setsInt = Int(sets),
              let repsInt = Int(reps),
              let weightInt = Int(weight),
              !exercise.isEmpty else { return }

      //  viewModel.addWorkout(exercise: exercise, sets: setsInt, reps: repsInt, weight: weightInt)
        presentationMode.wrappedValue.dismiss()
    }
}
