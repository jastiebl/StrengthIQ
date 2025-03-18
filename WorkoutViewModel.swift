import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    private let db = Firestore.firestore()

    // ✅ Fetch workouts from Firestore
    func fetchWorkouts() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userID).collection("workouts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("🔥 Error fetching workouts: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.workouts = snapshot?.documents.compactMap { document -> Workout? in
                        var workout = try? document.data(as: Workout.self)
                        workout?.id = document.documentID  // Ensure Firestore ID is stored
                        return workout
                    } ?? []
                }
            }
    }

    // ✅ Delete Workout
    func deleteWorkout(at offsets: IndexSet) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        for index in offsets {
            let workout = workouts[index]
            
            // Remove from Firestore
            db.collection("users").document(userID).collection("workouts").document(workout.id ?? "")
                .delete { error in
                    if let error = error {
                        print("🔥 Error deleting workout: \(error.localizedDescription)")
                    } else {
                        print("✅ Workout deleted successfully")
                    }
                }
        }
        
        // Remove from local state
        DispatchQueue.main.async {
            self.workouts.remove(atOffsets: offsets)
        }
    }

    // ✅ (Optional) Add a new workout
    func addWorkout(_ workout: Workout) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        do {
            let _ = try db.collection("users").document(userID).collection("workouts").addDocument(from: workout)
        } catch {
            print("🔥 Error adding workout: \(error.localizedDescription)")
        }
    }
}
