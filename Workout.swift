import Foundation
import FirebaseFirestore

struct Workout: Identifiable, Codable {
    @DocumentID var id: String?
    var exercise: String
    var sets: Int
    var reps: Int
    var weight: Int
    var timestamp: Date
}
