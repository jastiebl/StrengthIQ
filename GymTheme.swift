import SwiftUI

// ✅ Add a Color Extension to support hex codes
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (no alpha)
            (a, r, g, b) = (255, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        case 8: // ARGB
            (a, r, g, b) = ((int >> 24) & 0xff, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // Default to black if invalid hex
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// ✅ Updated GymTheme with proper colors
struct GymTheme {
    static let background = Color(hex: "#121212") // Deep Black
    static let cardBackground = Color(hex: "#1E1E1E") // Dark Gray
    static let text = Color.white
    static let accent = Color(hex: "#FF453A") // Vibrant Red
    static let secondaryAccent = Color(hex: "#0A84FF") // Bright Blue
    static let buttonBackground = Color(hex: "#FF5733") // Orange-Red
    static let inputField = Color(hex: "#1E1E1E") // Dark input fields

    // ✅ Fix missing colors
    static let grayTone = Color(hex: "#A0A0A0") // Light Gray for subtitles
    static let primary = accent // Use accent as the primary color
}
