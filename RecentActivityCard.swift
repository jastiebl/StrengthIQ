import SwiftUI

struct RecentActivityCard: View {
    var title: String
    var subtitle: String
    var icon: String

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(GymTheme.grayTone)
            .frame(height: 80)
            .overlay(
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(GymTheme.primary)
                        .font(.title2)

                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(GymTheme.text)

                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(GymTheme.grayTone)
                    }
                    Spacer()
                }
                .padding()
            )
            .transition(.move(edge: .trailing))
    }
}
