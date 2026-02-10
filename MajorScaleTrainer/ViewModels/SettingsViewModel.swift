import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var mode: QuizMode = .completeScales
    
    @Published var enabledIntervals: Set<Int> = Set(1...7) {
        didSet { saveIntervals() }
    }
    
    @Published var countdownEnabled: Bool = true {
        didSet { saveCountdownEnabled() }
    }
    
    @Published var countdown: Int = 0
    @Published var showCountdown: Bool = false
    let countdownTimer: Int = 2  // fixed duration
    
    private let intervalsKey = "enabledIntervals"
    private let countdownKey = "countdownEnabled"
    
    init() {
        loadSettings()
    }
    
    
    func toggleInterval(_ i: Int) {
        if enabledIntervals.contains(i) {
            if enabledIntervals.count > 1 {   // enforce at least one selected
                enabledIntervals.remove(i)
            }
        } else {
            enabledIntervals.insert(i)
        }
    }
    
    
    func startCountdown(completion: @escaping () -> Void) {
        guard countdownEnabled else {
            completion()
            return
        }
        
        showCountdown = true
        countdown = countdownTimer
        
        Task {
            while countdown > 0 {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                countdown -= 1
            }
            showCountdown = false
            completion()
        }
    }
    
    
    private func saveIntervals() {
        let array = Array(enabledIntervals)
        UserDefaults.standard.set(array, forKey: intervalsKey)
    }
    
    private func saveCountdownEnabled() {
        UserDefaults.standard.set(countdownEnabled, forKey: countdownKey)
    }
    
    private func loadSettings() {
        if let savedIntervals = UserDefaults.standard.array(forKey: intervalsKey) as? [Int], !savedIntervals.isEmpty {
            enabledIntervals = Set(savedIntervals)
        }
        
        if UserDefaults.standard.object(forKey: countdownKey) != nil {
            countdownEnabled = UserDefaults.standard.bool(forKey: countdownKey)
        }
    }
}
