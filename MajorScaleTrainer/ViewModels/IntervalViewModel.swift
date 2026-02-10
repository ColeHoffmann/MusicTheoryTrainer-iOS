import SwiftUI
import Combine

class IntervalViewModel: ObservableObject {
    let stats: StatsViewModel
    @ObservedObject var settings: SettingsViewModel

    @Published var currentScale: [String] = []
    @Published var scaleName: String = ""
    @Published var intervalIndex: Int = 0        // 1 = root, 2 = 2nd, etc.
    @Published var selectedAnswer: String? = nil
    @Published var hasMistake = false
    @Published var currentKeyboard: [String] = ScaleLibrary.sharpKeyboard
    
    private var lastScaleName: String? = "z" // Track last scale

    init(stats: StatsViewModel, settings: SettingsViewModel) {
        self.stats = stats
        self.settings = settings
        nextQuestion()
        lastScaleName = scaleName
    }

    func nextQuestion() {
           var newScale: [String]
           repeat {
               newScale = ScaleLibrary.randomScale()
           } while newScale[0] == lastScaleName  // repeat until it’s a new scale
           currentScale = newScale
           scaleName = currentScale[0] + " major"
           intervalIndex = settings.enabledIntervals.randomElement() ?? 1
           selectedAnswer = nil
           currentKeyboard = ScaleLibrary.keyboard(forScale: currentScale)
        hasMistake = false
        
        intervalIndex = settings.enabledIntervals.randomElement() ?? 1

    }
  
    func selectNote(_ note: String) {
        selectedAnswer = note
        let correct = currentScale[intervalIndex - 1]
        if note == correct {
            stats.recordResult(
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
