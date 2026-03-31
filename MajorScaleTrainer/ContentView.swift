//
//  ContentView.swift
//  MajorScaleTrainer
//
//  Created by Cole Hoffmann on 1/7/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var statsViewModel = StatsViewModel()

    var body: some View {
        NavigationView {
            Group {
                switch settingsViewModel.mode {
                    case .completeScales:
                        QuizView(viewModel: QuizViewModel(stats: statsViewModel, settings: settingsViewModel))
                    case .guessIntervals:
                    IntervalView(viewModel: IntervalViewModel(stats: statsViewModel, settings: settingsViewModel))
                    case .chords:
                    ChordView(viewModel: ChordViewModel(stats: statsViewModel, settings: settingsViewModel))
                }
            }
            .navigationTitle("Music Theory Trainer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

