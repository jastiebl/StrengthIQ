import SwiftUI

struct FoodSearchView: View {
    @State private var query: String = ""
    @State private var searchResults: [FoodItem] = []
    var onFoodSelected: (FoodItem) -> Void

    var body: some View {
        NavigationView {
            VStack {
                // 🔍 Search Bar
                TextField("Search for food...", text: $query, onCommit: fetchFoodData)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                // 📃 Results List
                List(searchResults) { food in
                    Button(action: { onFoodSelected(food) }) {
                        VStack(alignment: .leading) {
                            Text(food.name)
                                .font(.headline)
                            Text("Calories: \(food.calories, specifier: "%.0f") kcal")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Food Search")
        }
    }

    // 🔍 Fetch food data from USDA API
    func fetchFoodData() {
        guard !query.isEmpty else { return }

        let apiKey = "5Wut2Q3B3yZX8HgLKLQFjdORYtS29alamKRDzCGG" // 🔴 Replace with your actual API key
        let baseURL = "https://api.nal.usda.gov/fdc/v1/foods/search"
        let urlString = "\(baseURL)?query=\(query)&api_key=\(apiKey)"

        print("🔍 Fetching from: \(urlString)") // Debugging

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ API Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(FoodSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = decodedResponse.foods
                }
            } catch {
                print("❌ JSON Decoding Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
