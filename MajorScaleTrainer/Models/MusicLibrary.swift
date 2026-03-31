import Foundation

struct MusicLibrary{
    
    
    static let allScales = [
        ["C","D","E","F","G","A","B"],
        //["C♯","D♯","E♯","F♯","G♯","A♯","B♯"], Not really in COF
        ["D♭","E♭","F","G♭","A♭","B♭","C"],
        ["D","E","F♯","G","A","B","C♯"],
        ["E♭","F","G","A♭","B♭","C","D"],
        ["E","F♯","G♯","A","B","C♯","D♯"],
        ["F","G","A","B♭","C","D","E"],
        //["F♯","G♯","A♯","B","C♯","D♯","E♯"], DNE in COF
        ["G♭","A♭","B♭","C♭","D♭","E♭","F"],
        ["G","A","B","C","D","E","F♯"],
        ["A♭","B♭","C","D♭","E♭","F","G"],
        ["A","B","C♯","D","E","F♯","G♯"],
        ["B♭","C","D","E♭","F","G","A"],
        ["B","C♯","D♯","E","F♯","G♯","A♯"]
    ]
    
    static let sharpKeyboard = ["C", "C♯", "D", "D♯", "E", "E♯", "F", "F♯", "G", "G♯", "A", "A♯", "B", "B♯"]
    static let flatKeyboard  = ["C♭", "C", "D♭", "D", "E♭", "E", "F♭",  "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    static func keyboard(forScale scale: [String]) -> [String] {
           if scale.contains(where: { $0.contains("♭") }) {
               return flatKeyboard
           } else {
               return sharpKeyboard
           }
       }
       
     static func randomScale() -> [String] {
           allScales.randomElement()!
       }
    
    static func notes(forChord type: ChordType, in rootScale: [String]) -> [String] {
          let root = rootScale[0]
          switch type {
          case .major:
              return [rootScale[0], rootScale[2], rootScale[4]]
          case .minor:
              let minorThird = addFlat(to: rootScale[2])
              return [rootScale[0], minorThird, rootScale[4]]
          case .major7:
              return [rootScale[0], rootScale[2], rootScale[4], rootScale[6]]
          case .dominant7:
              let flatSeventh = addFlat(to: rootScale[6])
              return [rootScale[0], rootScale[2], rootScale[4], flatSeventh]
          case .minor7:
              let minorThird = addFlat(to: rootScale[2])
              let flatSeventh = addFlat(to: rootScale[6])
              return [rootScale[0], minorThird, rootScale[4], flatSeventh]
          }
      }

    static func addFlat(to note: String) -> String {
        if note.contains("♯") {
            return note.replacingOccurrences(of: "♯", with: "")
        } else if note.contains("♭") {
            return note + "♭"
        } else {
            return note + "♭"
        }
    }


    
}
