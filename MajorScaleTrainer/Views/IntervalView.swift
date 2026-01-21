import SwiftUI

struct IntervalView: View {
    
    @StateObject var viewModel: IntervalViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            // Interval Prompt
            Text("What's the \((viewModel.intervalIndex).ordinalString) of \(viewModel.scaleName)?")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            //Keyboard
            KeyboardComponent(notes: viewModel.currentKeyboard,isDisabled: viewModel.showCountdown ,buttonColor: buttonColor,onTap: viewModel.selectNote)
            
            // Feedback + Countdown stack (fixed height)
            VStack(spacing: 4) {
                if let selected = viewModel.selectedAnswer {
                    if selected == viewModel.currentScale[viewModel.intervalIndex - 1] {
                        Text("Correct!")
                            .foregroundColor(.green)
                            .font(.headline)
                    } else {
                        Text("Incorrect")
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                } else {
                    Text(" ") // placeholder before guess
                        .font(.headline)
                }
                
                CountdownComponent(isVisible: viewModel.showCountdown, countdown: viewModel.countdown)
            }
            .frame(height: 50) // reserve space like QuizView
            .padding(.bottom, 8)
            
            Spacer()
            
            // Score
            Text("Score: \(viewModel.performance.correctAnswers) / \(viewModel.performance.totalQuestions)")
                .font(.footnote)
                .padding(.bottom, 4)
            
        
            IntervalSelectionComponent(viewModel: viewModel).padding(.bottom, 16)
            
        }
        .padding(.horizontal, 16)
        .navigationBarItems(trailing: Button {
            showSettings = true
        } label: {
            Image(systemName: "line.horizontal.3") // hamburger icon
        })
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settingsViewModel, performance: viewModel.performance, isPresented: $showSettings)
        }
        
    }
    
    
    // MARK: Button Color Logic
    private func buttonColor(note: String) -> Color {
        if viewModel.selectedAnswer == note && note == viewModel.currentScale[viewModel.intervalIndex - 1] {
            return .green
        } else if viewModel.selectedAnswer == note && note != viewModel.currentScale[viewModel.intervalIndex - 1] {
            return .red
        } else {
            return .blue
        }
    }
    
}
