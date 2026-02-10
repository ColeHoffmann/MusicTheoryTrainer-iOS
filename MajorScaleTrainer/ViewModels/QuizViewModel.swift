import SwiftUI
import Combine

class QuizViewModel: ObservableObject {
    let stats: StatsViewModel
    @ObservedObject var settings: SettingsViewModel
    @Published var currentQuestion: ScaleQuestion
    @Published var filledNotes: [Int: String] = [:]
    @Published var guessedNotes: [String] = []
    @Published var hasMistake = false
    
    private var lastScaleName: String? = "z"  // Track last scale

    
    init(stats: StatsViewModel, settings: SettingsViewModel) {
        self.stats = stats
        self.settings = settings
        let indices = settings.enabledIntervals.map { $0 - 1 }.sorted()
        self.currentQuestion = QuizViewModel.generateRandomQuestion(missingIndices: indices, lastScale: lastScaleName)
        lastScaleName = currentQuestion.scaleName

    }
    
    func selectNote(_ note: String) {
          guessedNotes.append(note)

          if let index = currentQuestion.missingIndices.first(
              where: { filledNotes[$0] == nil && currentQuestion.notes[$0] == note }
          ) {
              filledNotes[index] = note

              if filledNotes.count == currentQuestion.missingIndices.count {
                  stats.recordResult(
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
        
        currentQuestion = QuizViewModel.generateRandomQuestion(missingIndices: indices, lastScale: lastScaleName)
        lastScaleName = currentQuestion.scaleName
        filledNotes = [:]
        guessedNotes = []
        hasMistake = false
    }
 
    static func generateRandomQuestion(missingIndices: [Int], lastScale: String?) -> ScaleQuestion {
        var scale: [String]
        repeat {
            scale = ScaleLibrary.randomScale()
        } while scale[0] == lastScale  // ensure it’s not the same as last
        let validIndices = missingIndices.filter { $0 < scale.count }
        return ScaleQuestion(scaleName: scale[0], notes: scale, missingIndices: validIndices)
    }
    
    // Current keyboard is always all notes
    var currentKeyboard: [String] { ScaleLibrary.keyboard(forScale: currentQuestion.notes) }
    
}
