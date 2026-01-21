import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var mode: QuizMode = .completeScales
}
