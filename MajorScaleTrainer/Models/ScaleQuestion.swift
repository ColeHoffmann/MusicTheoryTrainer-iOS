struct ScaleQuestion {
    let scaleName: String       // e.g. "C"
    let notes: [String]         // full scale
    let missingIndices: [Int]   // indices of missing notes
    var usesFlats: Bool {
        notes.contains { $0.contains("♭") }
    }

    // Display for UI: filled notes or "_"
    func displayedNotes(filledNotes: [Int: String]) -> [String] {
        notes.enumerated().map { index, note in
            if let filled = filledNotes[index] {
                return filled
            } else if missingIndices.contains(index) {
                return "_"
            } else {
                return note
            }
        }
    }
    
    var correctAnswers: [Int: String] {
        Dictionary(uniqueKeysWithValues: missingIndices.map { ($0, notes[$0]) })
    }
}
