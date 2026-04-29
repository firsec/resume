//
//  RebuildStore.swift
//  resume
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class RebuildStore: ObservableObject {
    @Published var selectedState: UserState?
    @Published var rituals: [Ritual]
    @Published var completions: [RitualCompletion]
    @Published var journalEntries: [JournalEntry]
    @Published var savedRitualIDs: Set<UUID>
    @Published var customTaskTitle: String

    init() {
        self.rituals = SampleContent.rituals
        self.completions = SampleContent.completions
        self.journalEntries = SampleContent.journalEntries
        self.savedRitualIDs = []
        self.customTaskTitle = "Put the phone away for ten minutes and read."
    }

    var recommendedRituals: [Ritual] {
        guard let selectedState else {
            return anchorRituals
        }

        let prioritizedTitles = switch selectedState {
        case .anxious:
            ["Brisk Walk 10 Minutes", "Warm Shower", "Baduanjin"]
        case .low:
            ["Cold Face Wash", "Cold Shower", "Sunlight + Water", "Desk Reset"]
        case .numb:
            ["Cold Shower", "Quiet Walk Without Phone", "Music Grounding"]
        case .irritated:
            ["Brisk Walk 10 Minutes", "Stretching", "Quiet Walk Without Phone"]
        case .procrastinating:
            ["Cold Shower", "Math Problem", "Desk Reset"]
        case .wantsCalm:
            ["Immersive Reading", "Warm Shower", "Baduanjin"]
        }

        let mapped = prioritizedTitles.compactMap { title in
            rituals.first(where: { $0.title == title })
        }

        return mapped.isEmpty ? anchorRituals : mapped
    }

    var anchorRituals: [Ritual] {
        [
            ritualForAnchor(.morningActivation, fallbackTitle: "Cold Shower"),
            ritualForAnchor(.middayRelease, fallbackTitle: "Brisk Walk 10 Minutes"),
            ritualForAnchor(.nightDecompression, fallbackTitle: "Baduanjin")
        ].compactMap { $0 }
    }

    func ritualForAnchor(_ category: RitualCategory, fallbackTitle: String) -> Ritual? {
        if let selectedState,
           let matched = rituals.first(where: { $0.category == category && $0.recommendedForStates.contains(selectedState) }) {
            return matched
        }

        return rituals.first(where: { $0.title == fallbackTitle })
    }

    func toggleSave(for ritual: Ritual) {
        if savedRitualIDs.contains(ritual.id) {
            savedRitualIDs.remove(ritual.id)
        } else {
            savedRitualIDs.insert(ritual.id)
        }
    }

    func isSaved(_ ritual: Ritual) -> Bool {
        savedRitualIDs.contains(ritual.id)
    }

    func ritual(withId id: UUID) -> Ritual? {
        rituals.first(where: { $0.id == id })
    }

    func completeRitual(
        ritual: Ritual,
        afterFeeling: AfterFeeling,
        bodyFeeling: String,
        reflectionText: String
    ) {
        completions.insert(
            RitualCompletion(
                ritualId: ritual.id,
                date: .now,
                beforeState: selectedState,
                afterFeeling: afterFeeling,
                bodyFeeling: bodyFeeling,
                reflectionText: reflectionText
            ),
            at: 0
        )
    }

    func upsertJournalEntry(segment: JournalSegment, text: String) {
        let calendar = Calendar.current
        if let index = journalEntries.firstIndex(where: { calendar.isDateInToday($0.date) }) {
            switch segment {
            case .completed:
                journalEntries[index].completedText = text
            case .felt:
                journalEntries[index].feltText = text
            case .understood:
                journalEntries[index].understoodText = text
            }
        } else {
            var entry = JournalEntry(date: .now, completedText: "", feltText: "", understoodText: "")
            switch segment {
            case .completed:
                entry.completedText = text
            case .felt:
                entry.feltText = text
            case .understood:
                entry.understoodText = text
            }
            journalEntries.insert(entry, at: 0)
        }
    }

    func text(for segment: JournalSegment, in entry: JournalEntry) -> String {
        switch segment {
        case .completed:
            entry.completedText
        case .felt:
            entry.feltText
        case .understood:
            entry.understoodText
        }
    }

    var weeklyProgress: WeeklyProgress {
        let calendar = Calendar.current
        let weekCompletions = completions.filter {
            calendar.isDate($0.date, equalTo: .now, toGranularity: .weekOfYear)
        }

        let mappedRituals = weekCompletions.compactMap { completion in
            ritual(withId: completion.ritualId)
        }

        let activationCount = mappedRituals.filter { $0.category == .morningActivation }.count
        let releaseCount = mappedRituals.filter { $0.category == .middayRelease }.count
        let decompressionCount = mappedRituals.filter { $0.category == .nightDecompression }.count
        let readingMinutes = mappedRituals
            .filter { $0.title == "Immersive Reading" }
            .reduce(0) { partialResult, _ in partialResult + 25 }
        let focusSessions = mappedRituals.filter { $0.category == .focusTraining }.count

        let grouped = Dictionary(grouping: mappedRituals, by: \.title)
        let mostEffectiveRitual = grouped.max(by: { $0.value.count < $1.value.count })?.key ?? "Brisk Walk 10 Minutes"

        return WeeklyProgress(
            activationCount: activationCount,
            releaseCount: releaseCount,
            decompressionCount: decompressionCount,
            readingMinutes: readingMinutes,
            focusSessions: focusSessions,
            mostEffectiveRitual: mostEffectiveRitual
        )
    }
}

final class FocusTimerViewModel: ObservableObject {
    @Published var remainingSeconds = 25 * 60
    @Published var isRunning = false
    @Published var answerText = ""

    private var timer: Timer?

    var displayTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var progress: Double {
        Double(25 * 60 - remainingSeconds) / Double(25 * 60)
    }

    func startPause() {
        isRunning.toggle()

        guard isRunning else {
            timer?.invalidate()
            timer = nil
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.isRunning = false
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        remainingSeconds = 25 * 60
    }
}

enum SampleContent {
    static let coldShower = Ritual(
        id: UUID(),
        title: "Cold Shower",
        subtitle: "Cold Activation",
        category: .morningActivation,
        duration: "2–5 min",
        intensity: .energizing,
        purpose: "Activate the body and interrupt the low-energy loop.",
        tags: ["Activation", "Wakefulness", "Break Procrastination"],
        steps: [
            "Take three slow breaths.",
            "Relax your shoulders and jaw.",
            "Start with cold water on your hands or face.",
            "Continue with a short cold shower if comfortable.",
            "Say: “I choose to begin again.”"
        ],
        icon: "drop",
        accentColor: .mist,
        recommendedForStates: [.low, .procrastinating, .numb]
    )

    static let coldFaceWash = Ritual(
        id: UUID(),
        title: "Cold Face Wash",
        subtitle: "A softer morning reset",
        category: .morningActivation,
        duration: "1–2 min",
        intensity: .gentle,
        purpose: "Wake up the senses without needing a full energy push.",
        tags: ["Reset", "Morning", "Gentle"],
        steps: [
            "Wash your face with cool water for 20 seconds.",
            "Hold a cool cloth against your cheeks and eyes.",
            "Drink a glass of water afterward.",
            "Stand by a window for one minute."
        ],
        icon: "drop.circle",
        accentColor: .mist,
        recommendedForStates: [.low, .anxious]
    )

    static let sunlightWater = Ritual(
        id: UUID(),
        title: "Sunlight + Water",
        subtitle: "A first signal to the body clock",
        category: .morningActivation,
        duration: "5 min",
        intensity: .gentle,
        purpose: "Give the body a clean daylight cue and a simple act of care.",
        tags: ["Morning", "Light", "Hydration"],
        steps: [
            "Open the curtains or step outside.",
            "Drink one glass of water slowly.",
            "Keep your eyes on the horizon for a few breaths."
        ],
        icon: "sun.max",
        accentColor: .sage,
        recommendedForStates: [.low]
    )

    static let briskWalk = Ritual(
        id: UUID(),
        title: "Brisk Walk 10 Minutes",
        subtitle: "Move the charge through",
        category: .middayRelease,
        duration: "10 min",
        intensity: .steady,
        purpose: "Break static thinking with rhythmic, grounded movement.",
        tags: ["Release", "Midday", "Movement"],
        steps: [
            "Leave your workspace.",
            "Walk with a quick but relaxed pace.",
            "Exhale a little longer than you inhale for the first minute.",
            "Come back with one next action in mind."
        ],
        icon: "figure.walk",
        accentColor: .sage,
        recommendedForStates: [.anxious, .irritated]
    )

    static let stretching = Ritual(
        id: UUID(),
        title: "Stretching",
        subtitle: "Loosen the jaw, shoulders, and hips",
        category: .middayRelease,
        duration: "6 min",
        intensity: .gentle,
        purpose: "Discharge irritation through slow extension instead of force.",
        tags: ["Release", "Mobility", "Reset"],
        steps: [
            "Roll your shoulders forward and back.",
            "Reach overhead and lengthen your side body.",
            "Fold forward with soft knees.",
            "Take five slow breaths before returning."
        ],
        icon: "figure.flexibility",
        accentColor: .sand,
        recommendedForStates: [.irritated, .anxious]
    )

    static let baduanjin = Ritual(
        id: UUID(),
        title: "Baduanjin",
        subtitle: "Evening decompression with a warm finish",
        category: .nightDecompression,
        duration: "12 min",
        intensity: .gentle,
        purpose: "Release stored tension and help the evening feel complete.",
        tags: ["Night", "Movement", "Decompression"],
        steps: [
            "Start with one minute of quiet standing.",
            "Move through one round of Baduanjin slowly.",
            "Let your breath guide each transition.",
            "Finish with a warm shower if possible."
        ],
        icon: "leaf",
        accentColor: .sand,
        recommendedForStates: [.anxious, .wantsCalm]
    )

    static let warmShower = Ritual(
        id: UUID(),
        title: "Warm Shower",
        subtitle: "A gentle evening softening",
        category: .nightDecompression,
        duration: "8 min",
        intensity: .gentle,
        purpose: "Signal to the body that the day can loosen its grip.",
        tags: ["Warmth", "Night", "Calm"],
        steps: [
            "Dim the lights if you can.",
            "Let the water warm your shoulders first.",
            "Breathe out fully once the warmth settles in.",
            "Finish without rushing back to screens."
        ],
        icon: "drop.fill",
        accentColor: .beige,
        recommendedForStates: [.anxious, .wantsCalm]
    )

    static let immersiveReading = Ritual(
        id: UUID(),
        title: "Immersive Reading",
        subtitle: "A longer reset for the weekend",
        category: .weekendDeepReset,
        duration: "25 min",
        intensity: .gentle,
        purpose: "Replace scattered input with one continuous line of attention.",
        tags: ["Weekend", "Reading", "Quiet"],
        steps: [
            "Choose one book before you sit down.",
            "Keep the phone in another room if possible.",
            "Read without highlighting or optimizing.",
            "Stop while the attention still feels intact."
        ],
        icon: "book",
        accentColor: .beige,
        recommendedForStates: [.wantsCalm, .anxious]
    )

    static let mathProblem = Ritual(
        id: UUID(),
        title: "Math Problem",
        subtitle: "A tiny logic spark",
        category: .focusTraining,
        duration: "3 min",
        intensity: .steady,
        purpose: "Use clean, bounded thinking to rebuild attention.",
        tags: ["Focus", "Logic", "Restart"],
        steps: [
            "Write the problem down.",
            "Solve it without opening another tab.",
            "Notice whether your attention feels a little sharper."
        ],
        icon: "function",
        accentColor: .mist,
        recommendedForStates: [.procrastinating, .numb]
    )

    static let deskReset = Ritual(
        id: UUID(),
        title: "Desk Reset",
        subtitle: "Clear the visual field",
        category: .custom,
        duration: "5 min",
        intensity: .gentle,
        purpose: "Reduce friction by making the next action easier to begin.",
        tags: ["Environment", "Reset", "Clarity"],
        steps: [
            "Remove obvious clutter.",
            "Keep only one active task visible.",
            "Wipe the surface and sit back down."
        ],
        icon: "sparkles",
        accentColor: .sage,
        recommendedForStates: [.low, .procrastinating]
    )

    static let quietWalk = Ritual(
        id: UUID(),
        title: "Quiet Walk Without Phone",
        subtitle: "Walk without input",
        category: .weekendDeepReset,
        duration: "15 min",
        intensity: .steady,
        purpose: "Let attention widen again without noise, feeds, or messages.",
        tags: ["Quiet", "Walk", "No-phone"],
        steps: [
            "Leave your phone behind if safe to do so.",
            "Walk at a conversational pace.",
            "Keep looking outward, not downward.",
            "Return before you feel depleted."
        ],
        icon: "figure.walk.motion",
        accentColor: .mist,
        recommendedForStates: [.numb, .irritated]
    )

    static let musicGrounding = Ritual(
        id: UUID(),
        title: "Music Grounding",
        subtitle: "One track, no scrolling",
        category: .custom,
        duration: "4 min",
        intensity: .gentle,
        purpose: "Use a single song to reconnect sensation and attention.",
        tags: ["Grounding", "Sound", "Return"],
        steps: [
            "Choose one track you already know.",
            "Sit or stand still while listening.",
            "Notice one body sensation before it ends."
        ],
        icon: "music.note",
        accentColor: .sand,
        recommendedForStates: [.numb]
    )

    static let rituals: [Ritual] = [
        coldShower,
        coldFaceWash,
        sunlightWater,
        briskWalk,
        stretching,
        baduanjin,
        warmShower,
        immersiveReading,
        mathProblem,
        deskReset,
        quietWalk,
        musicGrounding
    ]

    static let completions: [RitualCompletion] = [
        RitualCompletion(ritualId: briskWalk.id, date: .now.addingTimeInterval(-86_400), beforeState: .anxious, afterFeeling: .calmer, bodyFeeling: "Lighter chest", reflectionText: "The walk broke the spiral."),
        RitualCompletion(ritualId: coldShower.id, date: .now.addingTimeInterval(-172_800), beforeState: .procrastinating, afterFeeling: .awake, bodyFeeling: "Alert", reflectionText: "Starting fast mattered more than feeling ready."),
        RitualCompletion(ritualId: immersiveReading.id, date: .now.addingTimeInterval(-259_200), beforeState: .wantsCalm, afterFeeling: .calmer, bodyFeeling: "Settled", reflectionText: "Quiet focus felt restorative."),
        RitualCompletion(ritualId: mathProblem.id, date: .now.addingTimeInterval(-345_600), beforeState: .procrastinating, afterFeeling: .focused, bodyFeeling: "Less foggy", reflectionText: "A small win made starting easier.")
    ]

    static let journalEntries: [JournalEntry] = [
        JournalEntry(
            date: .now.addingTimeInterval(-86_400),
            completedText: "I took the walk even though I wanted to keep avoiding the afternoon.",
            feltText: "Restless at first, then more breathable.",
            understoodText: "Changing environment can be enough to shift the day."
        ),
        JournalEntry(
            date: .now.addingTimeInterval(-172_800),
            completedText: "Cold shower, desk reset, and one focus block.",
            feltText: "Reluctant, then awake.",
            understoodText: "Momentum is easier after a physical start."
        )
    ]
}
