//
//  FocusTrainingView.swift
//  resume
//

import SwiftUI

struct FocusTrainingView: View {
    @EnvironmentObject private var store: RebuildStore
    @StateObject private var timerViewModel = FocusTimerViewModel()

    var body: some View {
        SoftBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.xl) {
                    SectionHeader(
                        eyebrow: "Focus",
                        title: "Focus Training",
                        subtitle: "Use logic to rebuild attention."
                    )

                    SurfaceCard {
                        VStack(spacing: AppDesign.Spacing.lg) {
                            ProgressRing(progress: timerViewModel.progress, label: timerViewModel.displayTime)
                                .frame(width: 188, height: 188)
                                .frame(maxWidth: .infinity)

                            VStack(spacing: AppDesign.Spacing.xs) {
                                Text("Do one math problem")
                                    .font(.headline)
                                    .foregroundStyle(AppDesign.Colors.charcoal)
                                Text("17 × 8 = ?")
                                    .font(.title3.weight(.medium))
                                    .foregroundStyle(AppDesign.Colors.secondaryText)
                            }

                            TextField("Type your answer", text: $timerViewModel.answerText)
                                .textFieldStyle(.roundedBorder)

                            HStack(spacing: AppDesign.Spacing.sm) {
                                Button {
                                    timerViewModel.startPause()
                                } label: {
                                    SecondaryButton(title: timerViewModel.isRunning ? "Pause" : "Start", isSelected: timerViewModel.isRunning)
                                }
                                .buttonStyle(.plain)

                                Button {
                                    timerViewModel.reset()
                                } label: {
                                    SecondaryButton(title: "Reset", isSelected: false)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
                        ForEach([
                            ("Logic Puzzle", "Pattern recognition with low visual noise", "square.on.circle", AccentTone.sage),
                            ("Math Problem", "A bounded task to restart attention", "function", AccentTone.mist),
                            ("Focus History", "\(store.weeklyProgress.focusSessions) focus sessions this week", "clock", AccentTone.beige)
                        ], id: \.0) { item in
                            SurfaceCard {
                                HStack(spacing: AppDesign.Spacing.md) {
                                    RoundedIconBadge(systemName: item.2, tone: item.3)
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(item.0)
                                            .font(.headline)
                                            .foregroundStyle(AppDesign.Colors.charcoal)
                                        Text(item.1)
                                            .font(.subheadline)
                                            .foregroundStyle(AppDesign.Colors.secondaryText)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(AppDesign.Spacing.lg)
            }
        }
        .navigationTitle("Focus")
    }
}
