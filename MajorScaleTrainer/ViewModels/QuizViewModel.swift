import SwiftUI
import Combine

class QuizViewModel: ObservableObject {
    
    let performance: PerformanceStore
    
    @Published var currentQuestion: ScaleQuestion
    @Published var filledNotes: [Int: String] = [:]
    @Published var guessedNotes: [String] = []
    @Published var hasMistake = false
    @Published var mode: QuizMode = .completeScales
    @Published var showCountdown = false
    @Published var countdown = 3
    
    @Published var blanksCount = 7  // slider setting
    
    init(performance: PerformanceStore) {
        self.performance = performance
        self.currentQuestion = QuizViewModel.generateRandomQuestion(blanksCount: 7)
    }
    
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
                  startCountdown()
              }
          } else {
              hasMistake = true
          }
      }
    
    private func startCountdown() {
        showCountdown = true
        countdown = 3
        
        Task {
            while countdown > 0 {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                countdown -= 1
            }
            showCountdown = false
            nextQuestion()
        }
    }
    
    func nextQuestion() {
        currentQuestion = QuizViewModel.generateRandomQuestion(blanksCount: blanksCount)
        filledNotes = [:]
        guessedNotes = []
        hasMistake = false
        showCountdown = false
    }
    
    static func generateRandomQuestion(blanksCount: Int) -> ScaleQuestion {
        let scale = ScaleLibrary.randomScale()
        let indices = Array(0..<scale.count).shuffled().prefix(blanksCount)
        return ScaleQuestion(scaleName: scale[0], notes: scale, missingIndices: Array(indices))
    }
    
    // Current keyboard is always all notes
    var currentKeyboard: [String] { ScaleLibrary.keyboard(forScale: currentQuestion.notes) }
    
}
