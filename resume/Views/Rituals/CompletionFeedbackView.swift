//
//  CompletionFeedbackView.swift
//  resume
//

import SwiftUI

struct CompletionFeedbackView: View {
    @EnvironmentObject private var store: RebuildStore
    let ritual: Ritual

    @State private var selectedFeeling: AfterFeeling = .calmer
    @State private var reflectionText = ""
    @State private var bodyFeeling = "Breathing a little easier"
    @State private var didSave = false

    var body: some View {
        SoftBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.xl) {
                    SectionHeader(
                        eyebrow: "Reflection",
                        title: "How do you feel now?",
                        subtitle: "A short note helps the shift stay visible."
                    )

                    VStack(spacing: AppDesign.Spacing.sm) {
                        ForEach(AfterFeeling.allCases) { feeling in
                            Button {
                                selectedFeeling = feeling
                            } label: {
                                SecondaryButton(title: feeling.rawValue, isSelected: selectedFeeling == feeling)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    SurfaceCard {
                        VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
                            Text("Body feeling")
                                .font(.headline)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                            TextField("What shifted physically?", text: $bodyFeeling)
                                .textFieldStyle(.plain)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                        }
                    }

                    SurfaceCard {
                        VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
                            Text("What did you notice?")
                                .font(.headline)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                            TextField("Optional reflection", text: $reflectionText, axis: .vertical)
                                .lineLimit(5, reservesSpace: true)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                        }
                    }

                    Button {
                        store.completeRitual(
                            ritual: ritual,
                            afterFeeling: selectedFeeling,
                            bodyFeeling: bodyFeeling,
                            reflectionText: reflectionText
                        )
                        didSave = true
                    } label: {
                        PrimaryButton(title: didSave ? "Saved" : "Save Reflection")
                    }
                    .buttonStyle(.plain)
                }
                .padding(AppDesign.Spacing.lg)
            }
        }
        .navigationTitle("Afterward")
        .navigationBarTitleDisplayMode(.inline)
    }
}
