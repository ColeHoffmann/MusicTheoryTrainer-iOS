import Foundation

struct ScaleLibrary{
    
    
    static let allScales = [
        ["C","D","E","F","G","A","B"],
        //["C♯","D♯","E♯","F♯","G♯","A♯","B♯"],
        ["D♭","E♭","F","G♭","A♭","B♭","C"],
        ["D","E","F♯","G","A","B","C♯"],
        ["E♭","F","G","A♭","B♭","C","D"],
        ["E","F♯","G♯","A","B","C♯","D♯"],
        ["F","G","A","B♭","C","D","E"],
        ["F♯","G♯","A♯","B","C♯","D♯","E♯"],
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
    
}
