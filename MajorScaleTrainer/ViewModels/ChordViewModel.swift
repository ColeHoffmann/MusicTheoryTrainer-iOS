import SwiftUI
import Combine

class ChordViewModel: ObservableObject {
    let stats: StatsViewModel
    @ObservedObject var settings: SettingsViewModel

    @Published var currentChord: Chord
    @Published var filledNotes: [Int: String] = [:]
    @Published var guessedNotes: [String] = []
    @Published var hasMistake = false
    @Published var currentKeyboard = MusicLibrary.flatKeyboard

    init(stats: StatsViewModel, settings: SettingsViewModel) {
        self.stats = stats
        self.settings = settings
        self.currentChord = Chord(root: "C", type: .major, notes: ["C", "E", "G"], parentScale: ["C", "D", "E", "F", "G", "A", "B"])
        nextChord()
    }


    func selectNote(_ note: String) {
        guessedNotes.append(note)
        
        if let index = currentChord.notes.indices.first(where: { filledNotes[$0] == nil && currentChord.notes[$0] == note }) {
            filledNotes[index] = note

            if filledNotes.count == currentChord.notes.count {
                stats.recordResult(scale: currentChord.displayName, wasPerfect: !hasMistake)
                settings.startCountdown { self.nextChord() }
            }
        } else {
            hasMistake = true
        }
    }

    func nextChord() {
        let chord = generateRandomChord(settings: settings)
        self.currentChord = chord
        filledNotes = [:]
        guessedNotes = []
        hasMistake = false
        var standardKeyboard = MusicLibrary.keyboard(forScale: chord.parentScale)
        for note in chord.notes where !standardKeyboard.contains(note) {
            standardKeyboard.append(note)
        }
        self.currentKeyboard = standardKeyboard
    }

    private func generateRandomChord(settings: SettingsViewModel) -> Chord {
        let rootScale = MusicLibrary.allScales.randomElement()!
        let type = settings.enabledChordTypes.randomElement()!
        let notes = MusicLibrary.notes(forChord: type, in: rootScale)
        
        return Chord(root: rootScale[0], type: type, notes: notes, parentScale: rootScale)
    }

}
