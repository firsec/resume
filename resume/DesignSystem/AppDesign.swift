//
//  AppDesign.swift
//  resume
//

import SwiftUI

enum AppDesign {
    enum Colors {
        static let background = Color(red: 0.97, green: 0.95, blue: 0.92)
        static let surface = Color(red: 0.99, green: 0.98, blue: 0.96)
        static let elevatedSurface = Color.white.opacity(0.72)
        static let sage = Color(red: 0.49, green: 0.61, blue: 0.55)
        static let mist = Color(red: 0.56, green: 0.63, blue: 0.67)
        static let sand = Color(red: 0.82, green: 0.72, blue: 0.58)
        static let beige = Color(red: 0.91, green: 0.85, blue: 0.78)
        static let charcoal = Color(red: 0.18, green: 0.20, blue: 0.21)
        static let secondaryText = Color(red: 0.42, green: 0.45, blue: 0.46)
        static let line = Color.white.opacity(0.48)
        static let cardShadow = Color.black.opacity(0.06)
        static let pill = Color(red: 0.90, green: 0.91, blue: 0.88)
    }

    enum Spacing {
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }

    enum Radius {
        static let card: CGFloat = 24
        static let button: CGFloat = 20
        static let badge: CGFloat = 18
    }

    static let cardGradient = LinearGradient(
        colors: [Colors.surface, Colors.elevatedSurface],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentGradient = LinearGradient(
        colors: [Colors.sage, Colors.mist],
        startPoint: .leading,
        endPoint: .trailing
    )
}

enum AccentTone: String, Codable, CaseIterable {
    case sage
    case mist
    case sand
    case beige

    var color: Color {
        switch self {
        case .sage: AppDesign.Colors.sage
        case .mist: AppDesign.Colors.mist
        case .sand: AppDesign.Colors.sand
        case .beige: AppDesign.Colors.beige
        }
    }

    var softColor: Color {
        color.opacity(0.16)
    }
}
