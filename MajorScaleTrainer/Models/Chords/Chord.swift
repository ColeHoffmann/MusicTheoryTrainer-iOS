//
//  Chord.swift
//  MajorScaleTrainer
//
//  Created by Cole Hoffmann on 2/12/26.
//

import Foundation
struct Chord {
    let root: String
    let type: ChordType
    let notes: [String]
    let parentScale: [String]
     
    var displayName: String { root + type.suffix.replacingOccurrences(of: "major", with: "") }
}
