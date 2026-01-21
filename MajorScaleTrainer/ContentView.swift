//
//  ContentView.swift
//  MajorScaleTrainer
//
//  Created by Cole Hoffmann on 1/7/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var performanceStore = PerformanceStore()

    var body: some View {
        NavigationView {
            Group {
                switch settingsViewModel.mode {
                case .completeScales:
                    QuizView(
                        viewModel: QuizViewModel(performance: performanceStore),
                        settingsViewModel: settingsViewModel
                    )

                case .guessIntervals:
                    IntervalView(
                        viewModel: IntervalViewModel(performance: performanceStore),
                        settingsViewModel: settingsViewModel
                    )
                }
            }
            .navigationTitle("Music Theory Trainer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

