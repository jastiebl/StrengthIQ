import Foundation

// 🥗 Meal Struct - Represents a meal entry
struct Meal: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
}
