import Foundation
import Combine

class StatsViewModel: ObservableObject {
    
    @Published var totalQuestions: Int = 0 {
        didSet { save() }
    }
    @Published var correctAnswers: Int = 0 {
        didSet { save() }
    }
    @Published var wrongScales: [String: Int] = [:] {
        didSet { save() }
    }
    
    private let totalKey = "stats_totalQuestions"
    private let correctKey = "stats_correctAnswers"
    private let wrongScalesKey = "stats_wrongScales"
    
    init() {
        load()
    }
    
    var accuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }
    
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
    
    // MARK: - Persistence
    
    private func save() {
        UserDefaults.standard.set(totalQuestions, forKey: totalKey)
        UserDefaults.standard.set(correctAnswers, forKey: correctKey)
        UserDefaults.standard.set(wrongScales, forKey: wrongScalesKey)
    }
    
    private func load() {
        totalQuestions = UserDefaults.standard.integer(forKey: totalKey)
        correctAnswers = UserDefaults.standard.integer(forKey: correctKey)
        if let savedWrong = UserDefaults.standard.dictionary(forKey: wrongScalesKey) as? [String: Int] {
            wrongScales = savedWrong
        }
    }
}
