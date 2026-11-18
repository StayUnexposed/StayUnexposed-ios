import SwiftUI

/// The single composition root of the app. Dependencies are created once and
/// injected into the SwiftUI environment, which keeps features testable and
/// free of hard-coded singletons.
@MainActor
@Observable
final class AppDependencies {
    var itemService: ItemServing
    var favorites: FavoritesStore

    init(itemService: ItemServing, favorites: FavoritesStore) {
        self.itemService = itemService
        self.favorites = favorites
    }

    /// Wires the real implementations used by the running app.
    static var live: AppDependencies {
        AppDependencies(
            itemService: MockItemService(),
            favorites: FavoritesStore()
        )
    }

    /// Lightweight graph for Xcode previews.
    static var preview: AppDependencies {
        AppDependencies(
            itemService: MockItemService(),
            favorites: FavoritesStore(defaults: .preview)
        )
    }
}
