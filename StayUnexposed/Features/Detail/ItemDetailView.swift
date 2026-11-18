import SwiftUI

struct ItemDetailView: View {
    @Environment(AppDependencies.self) private var dependencies
    let item: Item

    private var isFavorite: Bool {
        dependencies.favorites.contains(item)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                CategoryTag(category: item.category)

                Text(item.title)
                    .font(.largeTitle.bold())

                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                RatingView(rating: item.rating)

                Divider()

                Text(item.body)
                    .font(.body)

                Button(isFavorite ? "Remove from favorites" : "Add to favorites") {
                    dependencies.favorites.toggle(item)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, Theme.Spacing.s)
            }
            .padding(Theme.Spacing.l)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dependencies.favorites.toggle(item)
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? Color.pink : Color.primary)
                }
                .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemDetailView(item: Item.samples[0])
    }
    .environment(AppDependencies.preview)
}
