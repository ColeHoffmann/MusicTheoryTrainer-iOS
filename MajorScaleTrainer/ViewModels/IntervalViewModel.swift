import SwiftUI
import Combine

class IntervalViewModel: ObservableObject {
    let performance: PerformanceStore

    @Published var currentScale: [String] = []
    @Published var scaleName: String = ""
    @Published var intervalIndex: Int = 0        // 1 = root, 2 = 2nd, etc.
    @Published var selectedAnswer: String? = nil
    @Published var totalAttempts = 0
    @Published var correctAnswers = 0
    @Published var showCountdown: Bool = false
    @Published var countdown: Int = 0
    @Published var hasMistake = false
    
    @Published var currentKeyboard: [String] = ScaleLibrary.sharpKeyboard
    @Published var enabledIntervals: Set<Int> = Set(1...7)
    
    init(performance: PerformanceStore) {
        self.performance = performance
        nextQuestion()
    }
    
    func toggleInterval(_ i: Int) {
            if enabledIntervals.contains(i) {
                if enabledIntervals.count > 1 {
                    enabledIntervals.remove(i)
                }
            } else {
                enabledIntervals.insert(i)
            }
        }

    func nextQuestion() {
        currentScale = ScaleLibrary.randomScale()
        scaleName = currentScale[0] + " major"
        intervalIndex = Int.random(in: 1...7)
        selectedAnswer = nil
        currentKeyboard = ScaleLibrary.keyboard(forScale: currentScale)
        hasMistake = false
        
        intervalIndex = enabledIntervals.randomElement() ?? 1

    }
  
    func selectNote(_ note: String) {
        selectedAnswer = note
        let correct = currentScale[intervalIndex - 1]
        if note == correct {
            performance.recordResult(
                scale: scaleName,
                wasPerfect: !hasMistake
            )
            startCountdown()
        } else {
            hasMistake = true
        }
    }
    
    func startCountdown() {
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
    }
