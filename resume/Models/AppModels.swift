//
//  AppModels.swift
//  resume
//

import Foundation

enum RitualCategory: String, CaseIterable, Codable, Identifiable {
    case morningActivation
    case middayRelease
    case nightDecompression
    case weekendDeepReset
    case focusTraining
    case custom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .morningActivation: "Morning Activation"
        case .middayRelease: "Midday Release"
        case .nightDecompression: "Night Decompression"
        case .weekendDeepReset: "Weekend Deep Reset"
        case .focusTraining: "Focus Training"
        case .custom: "Custom"
        }
    }

    var icon: String {
        switch self {
        case .morningActivation: "sun.max"
        case .middayRelease: "figure.walk"
        case .nightDecompression: "moon"
        case .weekendDeepReset: "book"
        case .focusTraining: "function"
        case .custom: "sparkles"
        }
    }
}

enum RitualIntensity: String, CaseIterable, Codable {
    case gentle
    case steady
    case energizing

    var label: String { rawValue.capitalized }
}

enum UserState: String, CaseIterable, Codable, Identifiable {
    case anxious
    case low
    case numb
    case irritated
    case procrastinating
    case wantsCalm

    var id: String { rawValue }

    var title: String {
        switch self {
        case .anxious: "Anxious"
        case .low: "Low"
        case .numb: "Numb"
        case .irritated: "Irritated"
        case .procrastinating: "Procrastinating"
        case .wantsCalm: "Want calm"
        }
    }

    var icon: String {
        switch self {
        case .anxious: "heart"
        case .low: "cloud.drizzle"
        case .numb: "moon.zzz"
        case .irritated: "flame"
        case .procrastinating: "hourglass"
        case .wantsCalm: "leaf"
        }
    }

    var shortDescription: String {
        switch self {
        case .anxious: "Choose grounding rituals that lower noise and help your body settle."
        case .low: "Use activation rituals to bring a little energy back online."
        case .numb: "Start with sensory cues that make the day feel more real again."
        case .irritated: "Move excess charge out through simple physical release."
        case .procrastinating: "Interrupt the stall with a small, decisive beginning."
        case .wantsCalm: "Lean into quiet rituals that soften the edges of the day."
        }
    }

    var recommendedCategories: [RitualCategory] {
        switch self {
        case .anxious: [.middayRelease, .nightDecompression, .weekendDeepReset]
        case .low: [.morningActivation, .middayRelease, .custom]
        case .numb: [.morningActivation, .weekendDeepReset, .focusTraining]
        case .irritated: [.middayRelease, .nightDecompression, .weekendDeepReset]
        case .procrastinating: [.morningActivation, .focusTraining, .custom]
        case .wantsCalm: [.nightDecompression, .weekendDeepReset, .middayRelease]
        }
    }
}

struct Ritual: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let category: RitualCategory
    let duration: String
    let intensity: RitualIntensity
    let purpose: String
    let tags: [String]
    let steps: [String]
    let icon: String
    let accentColor: AccentTone
    let recommendedForStates: [UserState]
}

enum AfterFeeling: String, CaseIterable, Identifiable {
    case calmer = "A little calmer"
    case awake = "More awake"
    case heavy = "Still heavy"
    case focused = "More focused"
    case proud = "Proud that I started"

    var id: String { rawValue }
}

struct RitualCompletion: Identifiable {
    let id = UUID()
    let ritualId: UUID
    let date: Date
    let beforeState: UserState?
    let afterFeeling: AfterFeeling
    let bodyFeeling: String
    let reflectionText: String
}

struct JournalEntry: Identifiable {
    let id = UUID()
    let date: Date
    var completedText: String
    var feltText: String
    var understoodText: String
}

struct WeeklyProgress {
    let activationCount: Int
    let releaseCount: Int
    let decompressionCount: Int
    let readingMinutes: Int
    let focusSessions: Int
    let mostEffectiveRitual: String
}

enum JournalSegment: String, CaseIterable, Identifiable {
    case completed = "What I completed"
    case felt = "What I felt"
    case understood = "What I understood"

    var id: String { rawValue }
}
