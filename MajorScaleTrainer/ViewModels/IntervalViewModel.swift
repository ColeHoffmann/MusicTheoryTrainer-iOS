import SwiftUI
import Combine

class IntervalViewModel: ObservableObject {
    let performance: PerformanceStore
    @ObservedObject var settings: SettingsViewModel

    @Published var currentScale: [String] = []
    @Published var scaleName: String = ""
    @Published var intervalIndex: Int = 0        // 1 = root, 2 = 2nd, etc.
    @Published var selectedAnswer: String? = nil
    @Published var hasMistake = false
    
    @Published var currentKeyboard: [String] = ScaleLibrary.sharpKeyboard

    
    init(performance: PerformanceStore, settings: SettingsViewModel) {
        self.performance = performance
        self.settings = settings
        nextQuestion()
    }

    func nextQuestion() {
        currentScale = ScaleLibrary.randomScale()
        scaleName = currentScale[0] + " major"
        intervalIndex = Int.random(in: 1...7)
        selectedAnswer = nil
        currentKeyboard = ScaleLibrary.keyboard(forScale: currentScale)
        hasMistake = false
        
        intervalIndex = settings.enabledIntervals.randomElement() ?? 1

    }
  
    func selectNote(_ note: String) {
        selectedAnswer = note
        let correct = currentScale[intervalIndex - 1]
        if note == correct {
            performance.recordResult(
                scale: scaleName,
                wasPerfect: !hasMistake
            )
            settings.startCountdown {
                self.nextQuestion()}
            } else {
            hasMistake = true
        }
    }
    
    }
