//
//  UIComponents.swift
//  resume
//

import SwiftUI

struct SoftBackgroundView<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            AppDesign.Colors.background
                .ignoresSafeArea()

            LinearGradient(
                colors: [AppDesign.Colors.beige.opacity(0.22), AppDesign.Colors.background],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            content
        }
    }
}

struct SurfaceCard<Content: View>: View {
    var background: AnyShapeStyle = AnyShapeStyle(AppDesign.cardGradient)
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(AppDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: AppDesign.Radius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppDesign.Radius.card, style: .continuous)
                    .stroke(AppDesign.Colors.line, lineWidth: 1)
            )
            .shadow(color: AppDesign.Colors.cardShadow, radius: 18, x: 0, y: 10)
    }
}

struct RoundedIconBadge: View {
    let systemName: String
    let tone: AccentTone
    var size: CGFloat = 54

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size / 2.5, style: .continuous)
                .fill(tone.softColor)
            Image(systemName: systemName)
                .font(.system(size: size * 0.36, weight: .semibold))
                .foregroundStyle(tone.color)
        }
        .frame(width: size, height: size)
    }
}

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: AppDesign.Spacing.xs) {
            if let icon {
                Image(systemName: icon)
            }
            Text(title)
        }
        .font(.headline)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppDesign.Spacing.md)
        .background(AppDesign.accentGradient)
        .clipShape(RoundedRectangle(cornerRadius: AppDesign.Radius.button, style: .continuous))
        .shadow(color: AppDesign.Colors.sage.opacity(0.22), radius: 14, x: 0, y: 8)
        .animation(.easeOut(duration: 0.2), value: title)
    }
}

struct SecondaryButton: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(isSelected ? AppDesign.Colors.charcoal : AppDesign.Colors.secondaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppDesign.Spacing.md)
            .background(isSelected ? AppDesign.Colors.beige.opacity(0.45) : AppDesign.Colors.surface.opacity(0.72))
            .clipShape(RoundedRectangle(cornerRadius: AppDesign.Radius.button, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppDesign.Radius.button, style: .continuous)
                    .stroke(AppDesign.Colors.line, lineWidth: 1)
            )
    }
}

struct TagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.medium))
            .foregroundStyle(AppDesign.Colors.secondaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(AppDesign.Colors.pill)
            .clipShape(Capsule())
    }
}

struct SectionHeader: View {
    let eyebrow: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
            Text(eyebrow.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(1.4)
                .foregroundStyle(AppDesign.Colors.secondaryText)
            Text(title)
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(AppDesign.Colors.charcoal)
            Text(subtitle)
                .font(.body)
                .foregroundStyle(AppDesign.Colors.secondaryText)
        }
    }
}

struct QuoteCard: View {
    let quote: String

    var body: some View {
        SurfaceCard(
            background: AnyShapeStyle(
                LinearGradient(
                    colors: [AppDesign.Colors.beige.opacity(0.68), AppDesign.Colors.surface],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        ) {
            VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
                Text("“\(quote)”")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(AppDesign.Colors.charcoal)
                Text("Rebuild note")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppDesign.Colors.secondaryText)
            }
        }
    }
}

struct RitualCard: View {
    let ritual: Ritual
    var categoryLabel: String? = nil

    var body: some View {
        SurfaceCard {
            HStack(alignment: .top, spacing: AppDesign.Spacing.md) {
                RoundedIconBadge(systemName: ritual.icon, tone: ritual.accentColor)

                VStack(alignment: .leading, spacing: AppDesign.Spacing.xs) {
                    if let categoryLabel {
                        Text(categoryLabel)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(AppDesign.Colors.secondaryText)
                    }
                    Text(ritual.title)
                        .font(.headline)
                        .foregroundStyle(AppDesign.Colors.charcoal)
                    Text(ritual.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(AppDesign.Colors.secondaryText)
                    HStack(spacing: AppDesign.Spacing.xs) {
                        Label(ritual.duration, systemImage: "clock")
                        Text("•")
                        Text(ritual.intensity.label)
                    }
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppDesign.Colors.secondaryText)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppDesign.Colors.secondaryText)
                    .padding(.top, 6)
            }
        }
    }
}

struct StateOptionCard: View {
    let state: UserState
    let isSelected: Bool

    var body: some View {
        SurfaceCard(background: cardBackground) {
            VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
                RoundedIconBadge(systemName: state.icon, tone: stateTone)
                Text(state.title)
                    .font(.headline)
                    .foregroundStyle(AppDesign.Colors.charcoal)
                Text(state.shortDescription)
                    .font(.subheadline)
                    .foregroundStyle(AppDesign.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, minHeight: 152, alignment: .topLeading)
        }
    }

    private var stateTone: AccentTone {
        switch state {
        case .anxious, .wantsCalm:
            .sage
        case .low, .procrastinating:
            .mist
        case .numb:
            .sand
        case .irritated:
            .beige
        }
    }

    private var cardBackground: AnyShapeStyle {
        if isSelected {
            AnyShapeStyle(stateTone.softColor)
        } else {
            AnyShapeStyle(AppDesign.cardGradient)
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let tone: AccentTone

    var body: some View {
        SurfaceCard(background: AnyShapeStyle(tone.softColor)) {
            VStack(alignment: .leading, spacing: AppDesign.Spacing.sm) {
                RoundedIconBadge(systemName: icon, tone: tone, size: 44)
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppDesign.Colors.secondaryText)
                Text(value)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(AppDesign.Colors.charcoal)
            }
        }
    }
}

struct ProgressRing: View {
    let progress: Double
    let label: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppDesign.Colors.pill, lineWidth: 18)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppDesign.accentGradient, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: AppDesign.Spacing.xs) {
                Text(label)
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppDesign.Colors.charcoal)
                Text("steady pace")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppDesign.Colors.secondaryText)
            }
        }
    }
}

struct MiniChartView: View {
    let values: [CGFloat]

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(Array(values.enumerated()), id: \.offset) { _, value in
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [AppDesign.Colors.sage.opacity(0.85), AppDesign.Colors.mist.opacity(0.55)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: max(value, 22))
            }
        }
        .frame(height: 88, alignment: .bottom)
    }
}

struct EntryCard: View {
    let title: String
    let bodyText: String

    var body: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: AppDesign.Spacing.xs) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppDesign.Colors.charcoal)
                Text(bodyText)
                    .font(.body)
                    .foregroundStyle(AppDesign.Colors.secondaryText)
            }
        }
    }
}
