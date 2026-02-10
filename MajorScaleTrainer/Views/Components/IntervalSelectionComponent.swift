import SwiftUI

struct IntervalSelectionComponent : View {
    @ObservedObject var settings: SettingsViewModel
    
    var body: some View {
    VStack(spacing: 6) {
        Text("Enabled Intervals:")
            .font(.caption2)
            .foregroundColor(.secondary)
        HStack(spacing: 12) {
            ForEach(1...7, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        settings.toggleInterval(i)
                    }
                } label: {
                    Text("\(i)")
                        .font(.subheadline)
                        .foregroundColor(settings.enabledIntervals.contains(i) ? .white : .black)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(settings.enabledIntervals.contains(i) ? Color.blue : Color.gray.opacity(0.3))
                        )
                }
            }
        }
        // Ordinal labels
        HStack(spacing: 12) {
            ForEach(1...7, id: \.self) { i in
                Text(i.ordinalString)  // using your Int extension
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(width: 32)
            }
        }
    }
    .padding(.top, 16)
    }
}
