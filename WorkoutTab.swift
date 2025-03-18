import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct WorkoutTab: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @State private var userName: String = "User"
    @State private var workoutDays: [String] = []
    @State private var muscleGroups: [String: String] = [:]
    @State private var todayWorkout: String = "Rest Day"
    @State private var isWorkoutViewPresented = false
    @State private var isAddWorkoutPresented = false

    let dayOfWeek = Calendar.current.component(.weekday, from: Date()) // 1 = Sunday, 2 = Monday, etc.
    let daysMap = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    var body: some View {
        ZStack {
            GymTheme.background.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // ✅ Title Section
                Text("Workout Time!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)

                Text("Hello, \(userName)!")
                    .font(.title2)
                    .foregroundColor(GymTheme.text)
                
                Text(todayWorkout == "Rest Day" ? "Enjoy your rest day! 💤" : "Happy \(todayWorkout) day! 💪")
                    .font(.headline)
                    .foregroundColor(todayWorkout == "Rest Day" ? .gray : .green)

                // ✅ 'Let's Lift' Button
                if todayWorkout != "Rest Day" {
                    Button(action: { isWorkoutViewPresented.toggle() }) {
                        HStack {
                            Image(systemName: "flame.fill")
                            Text("Let's Lift! 💪")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .fullScreenCover(isPresented: $isWorkoutViewPresented) {
                        WorkoutSessionView()
                    }
                }
                
                // ✅ Logged Workouts Section
                if !viewModel.workouts.isEmpty {
                    Text("Logged Workouts")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    List {
                        ForEach(viewModel.workouts, id: \.id) { workout in
                            VStack(alignment: .leading) {
                                Text(workout.exercise)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Sets: \(workout.sets) • Reps: \(workout.reps) • Weight: \(workout.weight) lbs")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: viewModel.deleteWorkout) // ✅ Corrected function call
                    }
                    .frame(height: 250)
                    .background(Color.clear)
                }

                // ✅ Add Workout Button
                Button(action: { isAddWorkoutPresented.toggle() }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Log Workout")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .sheet(isPresented: $isAddWorkoutPresented) {
                    AddWorkoutView(viewModel: viewModel)
                }

                Spacer()
            }
        }
        .onAppear {
            fetchUserWorkout()
            viewModel.fetchWorkouts()
        }
    }

    func fetchUserWorkout() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    self.userName = document.get("name") as? String ?? "User"
                    self.workoutDays = document.get("workoutDays") as? [String] ?? []
                    self.muscleGroups = document.get("muscleGroups") as? [String: String] ?? [:]

                    let today = daysMap[dayOfWeek - 1] // Convert weekday to string
                    self.todayWorkout = muscleGroups[today] ?? "Rest Day"
                }
            } else {
                print("🔥 Error fetching user workout data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

}
