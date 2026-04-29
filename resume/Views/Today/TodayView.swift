//
//  TodayView.swift
//  resume
//

import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var store: RebuildStore

    var body: some View {
        SoftBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.xl) {
                    SectionHeader(
                        eyebrow: "Today",
                        title: "Today’s Rebuild",
                        subtitle: "Start with one small anchor."
                    )

                    if let selectedState {
                        SurfaceCard(
                            background: AnyShapeStyle(
                                LinearGradient(
                                    colors: [AppDesign.Colors.mist.opacity(0.18), AppDesign.Colors.sage.opacity(0.14)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        ) {
                            VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
                                HStack {
                                    RoundedIconBadge(systemName: selectedState.icon, tone: .sage)
                                    Spacer()
                                    NavigationLink("Change state") {
                                        StateSelectionView()
                                    }
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(AppDesign.Colors.sage)
                                }
                                Text("You checked in as \(selectedState.title.lowercased()).")
                                    .font(.headline)
                                    .foregroundStyle(AppDesign.Colors.charcoal)
                                Text("Recommended right now")
                                    .font(.subheadline)
                                    .foregroundStyle(AppDesign.Colors.secondaryText)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppDesign.Spacing.md) {
                                        ForEach(store.recommendedRituals.prefix(3), id: \.id) { ritual in
                                            NavigationLink {
                                                RitualDetailView(ritual: ritual)
                                            } label: {
                                                CompactRecommendationCard(ritual: ritual)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    } else {
                        NavigationLink {
                            StateSelectionView()
                        } label: {
                            QuotePromptCard()
                        }
                        .buttonStyle(.plain)
                    }

                    VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
                        Text("Daily Anchors")
                            .font(.headline)
                            .foregroundStyle(AppDesign.Colors.charcoal)

                        ForEach(store.anchorRituals, id: \.id) { ritual in
                            NavigationLink {
                                RitualDetailView(ritual: ritual)
                            } label: {
                                RitualCard(ritual: ritual, categoryLabel: ritual.category.title)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    SurfaceCard {
                        VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
                            Text("Custom Task")
                                .font(.headline)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                            HStack(spacing: AppDesign.Spacing.md) {
                                RoundedIconBadge(systemName: "pencil", tone: .sand)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(store.customTaskTitle)
                                        .font(.body.weight(.medium))
                                        .foregroundStyle(AppDesign.Colors.charcoal)
                                    Text("Small tasks still count when they help you return to yourself.")
                                        .font(.subheadline)
                                        .foregroundStyle(AppDesign.Colors.secondaryText)
                                }
                            }
                        }
                    }

                    QuoteCard(quote: "You don’t need to become perfect today. Just return to yourself a little.")
                }
                .padding(AppDesign.Spacing.lg)
            }
        }
        .navigationTitle("Rebuild")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if selectedState == nil {
                    NavigationLink("Check in") {
                        StateSelectionView()
                    }
                    .foregroundStyle(AppDesign.Colors.sage)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AboutView()
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(AppDesign.Colors.secondaryText)
                }
            }
        }
        .animation(.easeOut(duration: 0.25), value: selectedState)
    }

    private var selectedState: UserState? {
        store.selectedState
    }
}

private struct QuotePromptCard: View {
    var body: some View {
        SurfaceCard(
            background: AnyShapeStyle(
                LinearGradient(
                    colors: [AppDesign.Colors.sand.opacity(0.20), AppDesign.Colors.surface],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        ) {
            HStack(spacing: AppDesign.Spacing.md) {
                RoundedIconBadge(systemName: "heart", tone: .sage)
                VStack(alignment: .leading, spacing: 6) {
                    Text("How are you feeling right now?")
                        .font(.headline)
                        .foregroundStyle(AppDesign.Colors.charcoal)
                    Text("Start with state recognition, then let Rebuild suggest a gentle next step.")
                        .font(.subheadline)
                        .foregroundStyle(AppDesign.Colors.secondaryText)
                }
                Spacer()
            }
        }
    }
}

private struct CompactRecommendationCard: View {
    let ritual: Ritual

    var body: some View {
        VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
            RoundedIconBadge(systemName: ritual.icon, tone: ritual.accentColor, size: 44)
            Text(ritual.title)
                .font(.headline)
                .foregroundStyle(AppDesign.Colors.charcoal)
            Text(ritual.duration)
                .font(.caption.weight(.medium))
                .foregroundStyle(AppDesign.Colors.secondaryText)
        }
        .padding(AppDesign.Spacing.md)
        .frame(width: 160, alignment: .leading)
        .background(AppDesign.Colors.surface.opacity(0.84))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppDesign.Colors.line, lineWidth: 1)
        )
    }
}
