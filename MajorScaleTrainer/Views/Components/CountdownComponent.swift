//
//  CountdownComponent.swift
//  MajorScaleTrainer
//
//  Created by Cole Hoffmann on 1/14/26.
//

import SwiftUI

struct CountdownComponent: View {
    let isVisible: Bool
    let countdown: Int
    
    var body: some View {
        VStack(spacing: 4) {
            if isVisible {
                Text("Next question in")
                    .foregroundColor(.green)
                    .font(.subheadline)
                
                Text("\(countdown)")
                    .font(.title)
                    .fontWeight(.bold)
            } else {
                Text(" ")
                    .font(.title)
            }
        }
        .frame(height: 50)
    }
}
