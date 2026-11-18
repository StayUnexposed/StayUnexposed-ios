import SwiftUI

struct HomeView: View {
    @Environment(AppDependencies.self) private var dependencies
    @State private var model: HomeViewModel

    init(service: ItemServing) {
        _model = State(initialValue: HomeViewModel(service: service))
    }

    var body: some View {
        content
            .navigationTitle("Home")
            .searchable(text: $model.searchText, prompt: "Search items")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reload", systemImage: "arrow.clockwise") {
                        Task { await model.reload() }
                    }
                }
            }
            .task { await model.loadIfNeeded() }
            .navigationDestination(for: Item.self) { item in
                ItemDetailView(item: item)
            }
    }

    @ViewBuilder
    private var content: some View {
        if model.visibleItems.isEmpty {
            emptyState
        } else {
            itemList
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        switch model.phase {
        case .idle, .loading:
            ProgressView("Loading items…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            ContentUnavailableView {
                Label("Couldn't load items", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task { await model.reload() }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        case .loaded:
            ContentUnavailableView(
                "No matches",
                systemImage: "magnifyingglass",
                description: Text("Try a different search term.")
            )
        }
    }

    private var itemList: some View {
        List(model.visibleItems) { item in
            NavigationLink(value: item) {
                ItemRow(item: item, isFavorite: dependencies.favorites.contains(item))
            }
            .swipeActions(edge: .trailing) {
                Button(
                    dependencies.favorites.contains(item) ? "Unfavorite" : "Favorite",
                    systemImage: dependencies.favorites.contains(item) ? "heart.slash" : "heart"
                ) {
                    dependencies.favorites.toggle(item)
                }
                .tint(.pink)
            }
        }
        .listStyle(.plain)
        .refreshable { await model.reload() }
        .accessibilityIdentifier("home.itemList")
    }
}

#Preview("Loaded") {
    NavigationStack {
        HomeView(service: MockItemService())
    }
    .environment(AppDependencies.preview)
}

#Preview("Failure") {
    NavigationStack {
        HomeView(service: FailingItemService())
    }
    .environment(AppDependencies.preview)
}
