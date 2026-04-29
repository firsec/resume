//
//  RitualExecutionView.swift
//  resume
//

import SwiftUI

struct RitualExecutionView: View {
    let ritual: Ritual
    @State private var progress = 0.38

    var body: some View {
        SoftBackgroundView {
            VStack(spacing: AppDesign.Spacing.xl) {
                Spacer(minLength: 8)

                RoundedIconBadge(systemName: ritual.icon, tone: ritual.accentColor, size: 76)

                VStack(spacing: AppDesign.Spacing.sm) {
                    Text(ritual.title)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(AppDesign.Colors.charcoal)
                    Text("One step at a time is enough.")
                        .font(.body)
                        .foregroundStyle(AppDesign.Colors.secondaryText)
                }

                ProgressRing(progress: progress, label: ritual.duration)
                    .frame(width: 220, height: 220)

                SurfaceCard {
                    VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
                        Text("Adjust the pacing")
                            .font(.headline)
                            .foregroundStyle(AppDesign.Colors.charcoal)
                        Text("Keep it steady and kind. This prototype uses a simple progress indicator.")
                            .font(.subheadline)
                            .foregroundStyle(AppDesign.Colors.secondaryText)
                        Slider(value: $progress, in: 0...1)
                            .tint(ritual.accentColor.color)
                    }
                }

                NavigationLink {
                    CompletionFeedbackView(ritual: ritual)
                } label: {
                    PrimaryButton(title: "Complete Ritual")
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(AppDesign.Spacing.lg)
        }
        .navigationTitle("In Progress")
        .navigationBarTitleDisplayMode(.inline)
    }
}
