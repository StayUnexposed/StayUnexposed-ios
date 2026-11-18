import SwiftUI
import Foundation

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.horizontal, Theme.Spacing.l)
            .padding(.vertical, Theme.Spacing.s)
            .background(Color.accentColor.opacity(configuration.isPressed ? 0.7 : 1), in: Capsule())
            .foregroundStyle(.white)
    }
}

struct CategoryTag: View {
    let category: Item.Category

    var body: some View {
        Label(category.title, systemImage: category.symbolName)
            .font(.caption.weight(.medium))
            .padding(.horizontal, Theme.Spacing.s)
            .padding(.vertical, Theme.Spacing.xs)
            .background(Color.accentColor.opacity(0.15), in: Capsule())
            .foregroundStyle(Color.accentColor)
    }
}

struct RatingView: View {
    let rating: Double

    var body: some View {
        Label(String(format: "%.1f", rating), systemImage: "star.fill")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .labelStyle(.titleAndIcon)
    }
}

struct ItemRow: View {
    let item: Item
    let isFavorite: Bool

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            VStack(alignment: .leading, spacing: Theme.Spacing.rowSpacing) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: Theme.Spacing.s) {
                    CategoryTag(category: item.category)
                    RatingView(rating: item.rating)
                }
            }

            Spacer(minLength: 0)

            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
                    .accessibilityLabel("Favorite")
            }
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

#Preview("Item row") {
    List(Item.samples.prefix(3)) { item in
        ItemRow(item: item, isFavorite: item.id == Item.samples[0].id)
    }
}
