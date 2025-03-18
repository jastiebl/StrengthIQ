import SwiftUI

struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.red)
                .padding(.leading, 10)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .padding(.vertical, 12)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .padding(.vertical, 12)
            }
        }
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 2))
        .padding(.horizontal, 10)
    }
}
