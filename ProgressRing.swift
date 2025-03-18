import SwiftUI

struct ProgressRing: View {
    var title: String
    var value: CGFloat
    var goal: CGFloat
    var icon: String

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(GymTheme.grayTone)

                Circle()
                    .trim(from: 0.0, to: value / goal)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .foregroundColor(GymTheme.primary)
                    .rotationEffect(Angle(degrees: -90))

                VStack {
                    Image(systemName: icon)
                        .foregroundColor(GymTheme.primary)
                        .font(.title2)

                    Text("\(Int(value)) / \(Int(goal))")
                        .font(.headline)
                        .foregroundColor(GymTheme.text)
                }
            }
            .frame(width: 100, height: 100)

            Text(title)
                .font(.subheadline)
                .foregroundColor(GymTheme.text)
        }
    }
}


