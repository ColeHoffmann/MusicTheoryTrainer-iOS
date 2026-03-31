import SwiftUI

struct ChordView: View {
    
    @StateObject var viewModel: ChordViewModel
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            Text(viewModel.currentChord.displayName)
                .font(.title)
                .fontWeight(.bold)
            
            HStack(spacing: 16) {
                ForEach(Array(viewModel.currentChord.notes.enumerated()), id: \.offset) { index, note in
                    VStack(spacing: 6) {
                        ZStack {
                            if let filled = viewModel.filledNotes[index] {
                                Text(filled)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .transition(.opacity)
                            } else {
                                Text(" ")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(height: 28)
                        
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 32, height: 4)
                        
                        Text((index + 1).ordinalString)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .frame(height: 14)
                    }
                    .frame(width: 40)
                }
            }
            .animation(.easeOut(duration: 0.2), value: viewModel.filledNotes)
            
            KeyboardComponent(
                notes: viewModel.currentKeyboard,
                isDisabled: viewModel.settings.showCountdown,
                buttonColor: buttonColor(note:),
                onTap: viewModel.selectNote
            )
            
            if !viewModel.guessedNotes.isEmpty && !viewModel.settings.showCountdown {
                if viewModel.filledNotes.count == viewModel.currentChord.notes.count && !viewModel.hasMistake {
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
            
            Text("Score: \(viewModel.stats.correctAnswers) / \(viewModel.stats.totalQuestions)")
                .font(.footnote)
            
            CountdownComponent(
                isVisible: viewModel.settings.countdownEnabled && viewModel.settings.showCountdown,
                countdown: viewModel.settings.countdown
            )
            
            HStack(spacing: 12) {
                ForEach(ChordType.allCases) { type in
                    Button {
                        if viewModel.settings.enabledChordTypes.contains(type) {
                            if viewModel.settings.enabledChordTypes.count > 1 { // enforce at least one
                                viewModel.settings.enabledChordTypes.remove(type)
                                        }                        } else {
                            viewModel.settings.enabledChordTypes.insert(type)
                        }
                    } label: {
                        Text(type.suffix)
                            .padding(8)
                            .background(
                                viewModel.settings.enabledChordTypes.contains(type)
                                ? Color.blue
                                : Color.gray.opacity(0.3)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.vertical, 16)
            
            Spacer()
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
