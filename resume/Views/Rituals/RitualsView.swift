//
//  RitualsView.swift
//  resume
//

import SwiftUI

struct RitualsView: View {
    @EnvironmentObject private var store: RebuildStore

    var body: some View {
        SoftBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.xl) {
                    SectionHeader(
                        eyebrow: "Rituals",
                        title: "Library of steadying actions",
                        subtitle: "Choose a ritual based on energy, time of day, or the kind of reset you need."
                    )

                    ForEach(RitualCategory.allCases.filter { $0 != .custom }) { category in
                        VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
                            Text(category.title)
                                .font(.headline)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                            ForEach(store.rituals.filter { $0.category == category }, id: \.id) { ritual in
                                NavigationLink {
                                    RitualDetailView(ritual: ritual)
                                } label: {
                                    RitualCard(ritual: ritual, categoryLabel: category.title)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(AppDesign.Spacing.lg)
            }
        }
        .navigationTitle("Rituals")
    }
}
