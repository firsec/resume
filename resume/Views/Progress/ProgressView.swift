//
//  ProgressView.swift
//  resume
//

import SwiftUI

struct ProgressView: View {
    @EnvironmentObject private var store: RebuildStore

    var body: some View {
        let progress = store.weeklyProgress

        SoftBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.xl) {
                    SectionHeader(
                        eyebrow: "Progress",
                        title: "Rebuild Track",
                        subtitle: "Progress without pressure. Rhythm counts more than perfection."
                    )

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: AppDesign.Spacing.md),
                            GridItem(.flexible(), spacing: AppDesign.Spacing.md)
                        ],
                        spacing: AppDesign.Spacing.md
                    ) {
                        MetricCard(title: "Activation sessions", value: "\(progress.activationCount)", icon: "sun.max", tone: .sage)
                        MetricCard(title: "Release sessions", value: "\(progress.releaseCount)", icon: "figure.walk", tone: .mist)
                        MetricCard(title: "Reading minutes", value: "\(progress.readingMinutes)", icon: "book", tone: .sand)
                        MetricCard(title: "Focus sessions", value: "\(progress.focusSessions)", icon: "function", tone: .beige)
                    }

                    SurfaceCard {
                        VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
                            Text("Weekly shape")
                                .font(.headline)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                            MiniChartView(values: [44, 66, 38, 82, 58, 72, 49])
                            Text("Soft visual placeholder for weekly rhythm.")
                                .font(.caption)
                                .foregroundStyle(AppDesign.Colors.secondaryText)
                        }
                    }

                    SurfaceCard {
                        VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
                            Text("Weekly Summary")
                                .font(.headline)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                            Text("You were not okay every day, but you were rebuilding your rhythm.")
                                .font(.title3.weight(.medium))
                                .foregroundStyle(AppDesign.Colors.charcoal)
                            Text("Most helpful ritual this week: \(progress.mostEffectiveRitual)")
                                .font(.body)
                                .foregroundStyle(AppDesign.Colors.secondaryText)
                        }
                    }
                }
                .padding(AppDesign.Spacing.lg)
            }
        }
        .navigationTitle("Progress")
    }
}
