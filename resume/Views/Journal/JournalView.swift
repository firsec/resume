//
//  JournalView.swift
//  resume
//

import SwiftUI

struct JournalView: View {
    @EnvironmentObject private var store: RebuildStore
    @State private var selectedSegment: JournalSegment = .completed
    @State private var currentText = "Write one small proof that you showed up today."

    var body: some View {
        SoftBackgroundView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.xl) {
                    SectionHeader(
                        eyebrow: "Journal",
                        title: "Reflection",
                        subtitle: "Write one small proof that you showed up today."
                    )

                    Picker("Journal Segment", selection: $selectedSegment) {
                        ForEach(JournalSegment.allCases) { segment in
                            Text(segment.rawValue).tag(segment)
                        }
                    }
                    .pickerStyle(.segmented)

                    SurfaceCard {
                        TextEditor(text: $currentText)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 260)
                            .foregroundStyle(AppDesign.Colors.charcoal)
                    }

                    Button {
                        store.upsertJournalEntry(segment: selectedSegment, text: currentText)
                    } label: {
                        PrimaryButton(title: "Save Note")
                    }
                    .buttonStyle(.plain)

                    VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
                        Text("Previous Entries")
                            .font(.headline)
                            .foregroundStyle(AppDesign.Colors.charcoal)

                        ForEach(store.journalEntries) { entry in
                            let text = store.text(for: selectedSegment, in: entry)
                            if !text.isEmpty {
                                EntryCard(
                                    title: entry.date.formatted(date: .abbreviated, time: .omitted),
                                    bodyText: text
                                )
                            }
                        }
                    }
                }
                .padding(AppDesign.Spacing.lg)
            }
        }
        .navigationTitle("Journal")
        .onAppear {
            if let firstEntry = store.journalEntries.first {
                currentText = store.text(for: selectedSegment, in: firstEntry)
            }
        }
        .onChange(of: selectedSegment) { _, newValue in
            if let firstEntry = store.journalEntries.first {
                currentText = store.text(for: newValue, in: firstEntry)
            } else {
                currentText = "Write one small proof that you showed up today."
            }
        }
    }
}
