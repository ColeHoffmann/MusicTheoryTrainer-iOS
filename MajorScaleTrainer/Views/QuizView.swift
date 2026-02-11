import SwiftUI

struct QuizView: View {
    
    @StateObject var viewModel: QuizViewModel
    @State private var showSettings = false
    
    var body: some View {
        VStack {
            
            // ---------- TOP SECTION ----------
            VStack(spacing: 24) {
                
                // Scale Title
                Text(viewModel.currentQuestion.scaleName + " Major")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Scale notes
                HStack(spacing: 16) {
                    ForEach(Array(viewModel.currentQuestion.notes.enumerated()), id: \.offset) { index, note in
                        VStack(spacing: 6) {
                            
                            // NOTE AREA
                            ZStack {
                                if viewModel.currentQuestion.missingIndices.contains(index) {
                                    if let filled = viewModel.filledNotes[index] {
                                        Text(filled)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .transition(.opacity)
                                    }
                                } else {
                                    Text(note)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(height: 28)
                            
                            // UNDERLINE
                            Rectangle()
                                .fill(
                                    viewModel.currentQuestion.missingIndices.contains(index)
                                    ? Color.black
                                    : Color.clear
                                )
                                .frame(width: 32, height: 4)
                            
                            // ORDINAL
                            Text((index + 1).ordinalString)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .frame(height: 14)
                        }
                        .frame(width: 40)
                    }
                }
                .padding(.top, 16)
                .animation(.easeOut(duration: 0.2), value: viewModel.filledNotes)
                
                // Feedback
                Group {
                    if !viewModel.guessedNotes.isEmpty && !viewModel.settings.showCountdown {
                        if viewModel.filledNotes.count == viewModel.currentQuestion.missingIndices.count && !viewModel.hasMistake {
                            Text("Correct!")
                                .foregroundColor(.green)
                                .font(.headline)
                        } else if viewModel.hasMistake {
                            Text("Some notes incorrect")
                                .foregroundColor(.red)
                                .font(.headline)
                        } else {
                            Text(" ")
                        }
                    } else {
                        Text(" ")
                    }
                }
                .frame(height: 24)
            }.padding(.top, 32)
            
            Spacer()   // ← the only spacer, separating sections
            
            // ---------- BOTTOM SECTION ----------
            VStack(spacing: 16) {
                
                KeyboardComponent(
                    notes: viewModel.currentKeyboard,
                    isDisabled: viewModel.settings.showCountdown,
                    buttonColor: buttonColor,
                    onTap: viewModel.selectNote
                )
                
                Text("Score: \(viewModel.stats.correctAnswers) / \(viewModel.stats.totalQuestions)")
                    .font(.footnote).padding(.top, 64)
                
                CountdownComponent(
                    isVisible: viewModel.settings.countdownEnabled && viewModel.settings.showCountdown,
                    countdown: viewModel.settings.countdown
                )
                
                IntervalSelectionComponent(settings: viewModel.settings)
            }
        }
        .padding(.horizontal, 16)
        .navigationBarItems(trailing: Button {
            showSettings = true
        } label: {
            Image(systemName: "line.horizontal.3")
        })
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: viewModel.settings, stats: viewModel.stats, isPresented: $showSettings)
        }
    }
    
    private func buttonColor(note: String) -> Color {
        if viewModel.filledNotes.values.contains(note) {
            return .green
        } else if viewModel.guessedNotes.contains(note) {
            return .gray
        } else {
            return .blue
        }
    }
}
