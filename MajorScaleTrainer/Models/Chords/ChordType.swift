//
//  ChordType.swift
//  MajorScaleTrainer
//
//  Created by Cole Hoffmann on 2/12/26.
//

import Foundation

enum ChordType: String, CaseIterable, Identifiable, Codable {
    case major
    case minor
    case major7
    case dominant7
    case minor7

    var id: String { rawValue }

    var suffix: String {
        switch self {
        case .major: return "major"
        case .minor: return "m"
        case .major7: return "Maj7"
        case .dominant7: return "7"
        case .minor7: return "m7"
        }
    }
}
