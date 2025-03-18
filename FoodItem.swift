import Foundation

struct FoodItem: Decodable, Identifiable {
    let id: Int
    let name: String
    let calories: Double
    let protein: Double
    let carbs: Double
    let fats: Double

    enum CodingKeys: String, CodingKey {
        case id = "fdcId"
        case name = "description"
        case foodNutrients
    }

    struct Nutrient: Decodable {
        let nutrientName: String
        let value: Double?
    }

    // ✅ Decode nested `foodNutrients` array
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let nutrients = try container.decode([Nutrient].self, forKey: .foodNutrients)

        calories = nutrients.first(where: { $0.nutrientName == "Energy" })?.value ?? 0
        protein = nutrients.first(where: { $0.nutrientName == "Protein" })?.value ?? 0
        carbs = nutrients.first(where: { $0.nutrientName == "Carbohydrate, by difference" })?.value ?? 0
        fats = nutrients.first(where: { $0.nutrientName == "Total lipid (fat)" })?.value ?? 0
    }
}

struct FoodSearchResponse: Decodable {
    let foods: [FoodItem]
}
