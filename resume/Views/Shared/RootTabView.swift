//
//  RootTabView.swift
//  resume
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TodayView()
            }
            .tabItem {
                Label("Today", systemImage: "sun.max")
            }

            NavigationStack {
                RitualsView()
            }
            .tabItem {
                Label("Rituals", systemImage: "leaf")
            }

            NavigationStack {
                FocusTrainingView()
            }
            .tabItem {
                Label("Focus", systemImage: "function")
            }

            NavigationStack {
                JournalView()
            }
            .tabItem {
                Label("Journal", systemImage: "pencil")
            }

            NavigationStack {
                ProgressView()
            }
            .tabItem {
                Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
        .tint(AppDesign.Colors.sage)
    }
}
