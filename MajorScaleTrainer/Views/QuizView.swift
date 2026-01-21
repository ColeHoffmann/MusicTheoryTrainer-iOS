import SwiftUI

struct QuizView: View {
    
    @StateObject var viewModel: QuizViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            // Scale Title
            Text(viewModel.currentQuestion.scaleName + " Major")
                .font(.title)
                .fontWeight(.bold)
            
            // Scale notes
            HStack(spacing: 16) {
                ForEach(Array(viewModel.currentQuestion.notes.enumerated()), id: \.offset) { index, note in
                    VStack(spacing: 6) {
                        
                        // --- NOTE AREA (fixed height for alignment) ---
                        ZStack {
                            if viewModel.currentQuestion.missingIndices.contains(index) {
                                // Missing note slot
                                if let filled = viewModel.filledNotes[index] {
                                    Text(filled)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .transition(.opacity)
                                }
                            } else {
                                // Already-known note
                                Text(note)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(height: 28)
                        
                        // --- UNDERLINE ---
                        Rectangle()
                            .fill(
                                viewModel.currentQuestion.missingIndices.contains(index)
                                ? Color.black
                                : Color.clear
                            )
                            .frame(width: 32, height: 4)
                        
                        // --- ORDINAL ---
                        Text((index + 1).ordinalString)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .frame(height: 14)
                    }
                    .frame(width: 40)
                }
            }
            .animation(.easeOut(duration: 0.2), value: viewModel.filledNotes)
            
            
            Spacer()
            
            
            // Keyboard
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(viewModel.currentKeyboard, id: \.self) { note in
                    Button {
                        viewModel.selectNote(note)
                    } label: {
                        Text(note)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(buttonColor(note: note))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.guessedNotes.contains(note))
                }
            }
            
            // Feedback
            if !viewModel.guessedNotes.isEmpty && !viewModel.showCountdown {
                if viewModel.filledNotes.count == viewModel.currentQuestion.missingIndices.count && !viewModel.hasMistake {
                    Text("Correct!")
                        .foregroundColor(.green)
                        .font(.headline)
                        .frame(height: 24)
                } else if viewModel.hasMistake {
                    Text("Some notes incorrect")
                        .foregroundColor(.red)
                        .font(.headline)
                        .frame(height: 24)
                } else {
                    Text(" ")
                        .frame(height: 24)
                }
            }
            
            Spacer()
            
            Text("Score: \(viewModel.performance.correctAnswers) / \(viewModel.performance.totalQuestions)")
                .font(.footnote)
            
            // Countdown
            CountdownComponent(isVisible: viewModel.showCountdown, countdown: viewModel.countdown)
            
            // --- Slider at the very bottom ---
            if viewModel.mode == .completeScales {
                VStack(spacing: 4) {
                    Text("Number of Notes to Fill In: \(viewModel.blanksCount)")
                        .font(.subheadline)
                    
                    Slider(value: Binding(
                        get: { Double(viewModel.blanksCount) },
                        set: { newVal in
                            viewModel.blanksCount = Int(newVal)
                        }
                    ), in: 1...7,
                           step: 1,
                           onEditingChanged: { editing in
                        if !editing {
                            viewModel.nextQuestion()
                        }
                    }
                           
                           
                    )
                    .padding(.horizontal)
                }
                .padding(.bottom, 16)
            }
        }
        .padding(.horizontal, 16)
        .navigationBarItems(trailing: Button {
            showSettings = true
        } label: {
            Image(systemName: "line.horizontal.3")
        })
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settingsViewModel, performance: viewModel.performance, isPresented: $showSettings)
        }
    }
    
    // Button Color Logic
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
