//
//  KeyboardComponent.swift
//  MajorScaleTrainer
//
//  Created by Cole Hoffmann on 1/14/26.
//
import SwiftUI

struct KeyboardComponent: View {
    let notes: [String]
    let isDisabled: Bool
    let buttonColor: (String) -> Color
    let onTap: (String) -> Void

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
            ForEach(notes, id: \.self) { note in
                Button {
                    onTap(note)
                } label: {
                    Text(note)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(buttonColor(note))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isDisabled)
            }
        }
    }
}
