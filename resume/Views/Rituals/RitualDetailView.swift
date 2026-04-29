//
//  RitualDetailView.swift
//  resume
//

import SwiftUI

struct RitualDetailView: View {
    @EnvironmentObject private var store: RebuildStore
    let ritual: Ritual

    var body: some View {
        SoftBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.xl) {
                    SurfaceCard {
                        VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
                            RoundedIconBadge(systemName: ritual.icon, tone: ritual.accentColor, size: 72)
                            Text(ritual.subtitle)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(AppDesign.Colors.secondaryText)
                            Text(ritual.title)
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(AppDesign.Colors.charcoal)

                            HStack(spacing: AppDesign.Spacing.md) {
                                Label(ritual.duration, systemImage: "clock")
                                Label(ritual.intensity.label, systemImage: "heart")
                            }
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(AppDesign.Colors.secondaryText)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
                                ForEach(ritual.tags, id: \.self) { tag in
                                    TagPill(text: tag)
                                }
                            }
                        }
                    }

                    EntryCard(title: "Purpose", bodyText: ritual.purpose)

                    SurfaceCard {
                        VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
                            Text("Steps")
                                .font(.headline)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                            ForEach(Array(ritual.steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: AppDesign.Spacing.sm) {
                                    Text("\(index + 1)")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(AppDesign.Colors.sage)
                                        .frame(width: 28, height: 28)
                                        .background(AppDesign.Colors.sage.opacity(0.14))
                                        .clipShape(Circle())
                                    Text(step)
                                        .font(.body)
                                        .foregroundStyle(AppDesign.Colors.charcoal)
                                }
                            }
                        }
                    }

                    VStack(spacing: AppDesign.Spacing.sm) {
                        NavigationLink {
                            RitualExecutionView(ritual: ritual)
                        } label: {
                            PrimaryButton(title: "Start Ritual")
                        }
                        .buttonStyle(.plain)

                        Button {
                            store.toggleSave(for: ritual)
                        } label: {
                            SecondaryButton(title: store.isSaved(ritual) ? "Saved" : "Save", isSelected: store.isSaved(ritual))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(AppDesign.Spacing.lg)
            }
        }
        .navigationTitle("Ritual")
        .navigationBarTitleDisplayMode(.inline)
    }
}
