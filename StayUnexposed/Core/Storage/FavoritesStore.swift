import Foundation
import Observation

/// Persists the user's favorites locally. Kept deliberately small so it can be
/// swapped for SwiftData or a remote sync layer without touching the views.
@MainActor
@Observable
final class FavoritesStore {
    private static let storageKey = "favorites.items"

    private let defaults: UserDefaults
    private(set) var items: [Item] = []

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func contains(_ item: Item) -> Bool {
        items.contains { $0.id == item.id }
    }

    func toggle(_ item: Item) {
        if contains(item) {
            items.removeAll { $0.id == item.id }
        } else {
            items.insert(item, at: 0)
        }
        persist()
    }

    func removeAll() {
        items.removeAll()
        persist()
    }

    private func load() {
        guard let data = defaults.data(forKey: Self.storageKey) else { return }
        items = (try? JSONDecoder().decode([Item].self, from: data)) ?? []
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: Self.storageKey)
    }
}

extension UserDefaults {
    /// An isolated suite so previews and tests never touch the real store.
    static let preview: UserDefaults = {
        let suite = "com.stayunexposed.StayUnexposed.preview"
        UserDefaults.standard.removePersistentDomain(forName: suite)
        return UserDefaults(suiteName: suite) ?? .standard
    }()
}
