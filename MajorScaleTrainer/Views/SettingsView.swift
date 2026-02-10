import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: SettingsViewModel
    @ObservedObject var stats: StatsViewModel
    @Binding var isPresented: Bool
    
    @State private var localMode: QuizMode = .completeScales
    
    var body: some View {
        VStack(spacing: 24) {
            
            // --- Settings Title ---
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // --- Mode Section ---
                    VStack(spacing: 12) {
                        Text("Mode")
                            .font(.headline)
                        
                        Text("Select a mode")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Picker("Mode", selection: $localMode) {
                            Text("Complete Scales").tag(QuizMode.completeScales)
                            Text("Guess Intervals").tag(QuizMode.guessIntervals)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    
                    Divider()
                    
                        
                    // --- Countdown Section ---
                    VStack(spacing: 12) {
                        Text("Countdown")
                            .font(.headline)
                        
                        Text("Show countdown after correct answer:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Centered Toggle
                        Toggle("", isOn: $settings.countdownEnabled)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .labelsHidden()                     // hide any label space
                            .frame(width: 50)                   // small width for the toggle
                            .frame(maxWidth: .infinity)         // expand container
                            .multilineTextAlignment(.center)    // center
                    }
                    .padding(.horizontal)

                    
                    Divider()

                    
                    // --- Stats Section ---
                    VStack(spacing: 12) {
                        Text("Stats")
                            .font(.headline)
                        
                        Text("Score: \(stats.correctAnswers)/\(stats.totalQuestions) (\(getAccuracyText()))")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        // Missed Scales
                        if !stats.wrongScales.isEmpty {
                            Text("Top missed scales:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            ForEach(stats.wrongScales.sorted(by: { $0.value > $1.value }).prefix(3), id: \.key) { scale, timesMissed in
                                Text("\(scale) — missed \(timesMissed) time\(timesMissed > 1 ? "s" : "")")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Reset button
                        Button("Reset All Scores") {
                            stats.resetAll()
                        }
                        .font(.footnote)
                        .padding(6)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(6)
                        .padding(.top, 4)
                    }
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    
                    Divider()
                }
                .padding(.top)
            }
            
            // --- Done Button pinned at bottom ---
            Button("Done") {
                settings.mode = localMode
                isPresented = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal)
        }
        .onAppear {
            localMode = settings.mode
        }
    }
    
    private func getAccuracyText() -> String {
        if stats.totalQuestions == 0 {
            return "Unavailable"
        } else {
            return String(format: "%.2f%%", stats.accuracy)
        }
    }
}
