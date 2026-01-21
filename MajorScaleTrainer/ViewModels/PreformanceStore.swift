import Foundation
import Combine

class PerformanceStore: ObservableObject {

    @Published var totalQuestions = 0
    @Published var correctAnswers = 0

    // key = scale name ("C", "F#", etc)
    // value = number of times user struggled with it
    @Published var wrongScales: [String: Int] = [:]


    var accuracy: Double { Double(correctAnswers) / Double(totalQuestions) * 100 }

    
    func recordResult(scale: String, wasPerfect: Bool) {
        totalQuestions += 1
        if wasPerfect {
            correctAnswers += 1
        } else {
            wrongScales[scale, default: 0] += 1
        }
    }

    func resetAll() {
        totalQuestions = 0
        correctAnswers = 0
        wrongScales = [:]
    }
}
