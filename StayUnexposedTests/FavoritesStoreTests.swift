import Foundation
import Testing

@testable import StayUnexposed

@MainActor
struct FavoritesStoreTests {
    private func makeDefaults() -> UserDefaults {
        let suite = "FavoritesStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)
        return defaults
    }

    @Test("Toggling adds then removes an item")
    func toggleRoundTrip() {
        let store = FavoritesStore(defaults: makeDefaults())
        let item = Item.samples[0]

        store.toggle(item)
        #expect(store.contains(item))
        #expect(store.items.count == 1)

        store.toggle(item)
        #expect(!store.contains(item))
        #expect(store.items.isEmpty)
    }

    @Test("Favorites survive a new store instance")
    func favoritesPersist() {
        let defaults = makeDefaults()
        let item = Item.samples[1]

        FavoritesStore(defaults: defaults).toggle(item)

        let reloaded = FavoritesStore(defaults: defaults)
        #expect(reloaded.contains(item))
    }

    @Test("Newest favorite is listed first")
    func newestFavoriteComesFirst() {
        let store = FavoritesStore(defaults: makeDefaults())

        store.toggle(Item.samples[0])
        store.toggle(Item.samples[1])

        #expect(store.items.first?.id == Item.samples[1].id)
    }
}
