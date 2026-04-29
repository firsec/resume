//
//  StateSelectionView.swift
//  resume
//

import SwiftUI

struct StateSelectionView: View {
    @EnvironmentObject private var store: RebuildStore
    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.flexible(), spacing: AppDesign.Spacing.md),
        GridItem(.flexible(), spacing: AppDesign.Spacing.md)
    ]

    var body: some View {
        SoftBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.xl) {
                    SectionHeader(
                        eyebrow: "Check In",
                        title: "How are you feeling right now?",
                        subtitle: "Choose what feels closest. Rebuild will adapt its suggestions without judgment."
                    )

                    LazyVGrid(columns: columns, spacing: AppDesign.Spacing.md) {
                        ForEach(UserState.allCases) { state in
                            Button {
                                store.selectedState = state
                                dismiss()
                            } label: {
                                StateOptionCard(state: state, isSelected: store.selectedState == state)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(AppDesign.Spacing.lg)
            }
        }
        .navigationTitle("State")
        .navigationBarTitleDisplayMode(.inline)
    }
}
