import SwiftUI

struct FavoritesView: View {
    @Environment(AppDependencies.self) private var dependencies

    var body: some View {
        Group {
            if dependencies.favorites.items.isEmpty {
                ContentUnavailableView(
                    "No favorites yet",
                    systemImage: "heart",
                    description: Text("Tap the heart on any item to keep it here.")
                )
            } else {
                List {
                    ForEach(dependencies.favorites.items) { item in
                        NavigationLink(value: item) {
                            ItemRow(item: item, isFavorite: true)
                        }
                    }
                    .onDelete { offsets in
                        let current = dependencies.favorites.items
                        for index in offsets {
                            dependencies.favorites.toggle(current[index])
                        }
                    }
                }
                .listStyle(.plain)
                .accessibilityIdentifier("favorites.itemList")
            }
        }
        .navigationTitle("Favorites")
        .navigationDestination(for: Item.self) { item in
            ItemDetailView(item: item)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
    .environment(AppDependencies.preview)
}
