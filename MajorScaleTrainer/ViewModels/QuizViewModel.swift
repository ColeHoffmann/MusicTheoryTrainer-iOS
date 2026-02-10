import SwiftUI
import Combine

class QuizViewModel: ObservableObject {
    let performance: PerformanceStore
    @ObservedObject var settings: SettingsViewModel
    @Published var currentQuestion: ScaleQuestion
    @Published var filledNotes: [Int: String] = [:]
    @Published var guessedNotes: [String] = []
    @Published var hasMistake = false
    @Published var mode: QuizMode = .completeScales
    
    init(performance: PerformanceStore, settings: SettingsViewModel) {
        self.performance = performance
        self.settings = settings
        let indices = settings.enabledIntervals.map { $0 - 1 }.sorted()
        self.currentQuestion = QuizViewModel.generateRandomQuestion(missingIndices: indices)    }
    
    func selectNote(_ note: String) {
          guessedNotes.append(note)

          if let index = currentQuestion.missingIndices.first(
              where: { filledNotes[$0] == nil && currentQuestion.notes[$0] == note }
          ) {
              filledNotes[index] = note

              if filledNotes.count == currentQuestion.missingIndices.count {
                  performance.recordResult(
                      scale: currentQuestion.scaleName,
                      wasPerfect: !hasMistake
                  )
                  settings.startCountdown {self.nextQuestion()}
              }
          } else {
              hasMistake = true
          }
      }
    
    func nextQuestion() {
        let indices = settings.enabledIntervals.map { $0 - 1 }.sorted()
        
        currentQuestion = QuizViewModel.generateRandomQuestion(missingIndices: indices)

        filledNotes = [:]
        guessedNotes = []
        hasMistake = false
    }

    
    static func generateRandomQuestion(missingIndices: [Int]) -> ScaleQuestion {
        let scale = ScaleLibrary.randomScale()
        // Make sure we only include valid indices
        let validIndices = missingIndices.filter { $0 < scale.count }
        return ScaleQuestion(scaleName: scale[0], notes: scale, missingIndices: validIndices)
    }
    
    // Current keyboard is always all notes
    var currentKeyboard: [String] { ScaleLibrary.keyboard(forScale: currentQuestion.notes) }
    
}
