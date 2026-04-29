//
//  AboutView.swift
//  resume
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        SoftBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.xl) {
                    SectionHeader(
                        eyebrow: "About",
                        title: "Rebuild",
                        subtitle: "A calm, ritual-based self-management tool for returning to structure, attention, and daily steadiness."
                    )

                    SurfaceCard {
                        VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
                            Text("Disclaimer")
                                .font(.headline)
                                .foregroundStyle(AppDesign.Colors.charcoal)
                            Text("Rebuild is a self-care and routine-building tool. It does not provide medical advice, diagnosis, or treatment. If you are in crisis or may harm yourself, contact local emergency services or a crisis hotline immediately.")
                                .font(.body)
                                .foregroundStyle(AppDesign.Colors.secondaryText)
                        }
                    }
                }
                .padding(AppDesign.Spacing.lg)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}
