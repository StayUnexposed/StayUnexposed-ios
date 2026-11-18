import Foundation

/// In-memory implementation with a small artificial latency, used by default so
/// the app runs with no network and by tests to stay deterministic.
struct MockItemService: ItemServing {
    var latency: Duration = .milliseconds(350)
    var items: [Item] = Item.samples

    func fetchItems() async throws -> [Item] {
        try await Task.sleep(for: latency)
        return items
    }
}

/// Returns a failure, handy for previewing error states.
struct FailingItemService: ItemServing {
    var error: APIError = .invalidResponse

    func fetchItems() async throws -> [Item] {
        throw error
    }
}
