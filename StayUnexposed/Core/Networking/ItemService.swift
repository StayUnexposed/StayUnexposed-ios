import Foundation

/// Read access to the item catalogue. Views only ever depend on this protocol.
protocol ItemServing: Sendable {
    func fetchItems() async throws -> [Item]
}

/// Talks to the network and maps transport models into domain models.
struct RemoteItemService: ItemServing {
    private let client: URLSessionHTTPClient

    init(client: URLSessionHTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }

    func fetchItems() async throws -> [Item] {
        let request = try Endpoint(path: "posts").request()
        let posts = try await client.decode([Post].self, from: request)
        return posts.prefix(20).map(\.asItem)
    }

    private struct Post: Decodable {
        let id: Int
        let title: String
        let body: String

        var asItem: Item {
            Item(
                id: UUID(deterministicFrom: id),
                title: title.capitalized,
                subtitle: "Post #\(id)",
                body: body,
                category: Item.Category.allCases[id % Item.Category.allCases.count],
                rating: Double(3 + (id % 21)) / 5
            )
        }
    }
}

private extension UUID {
    /// Stable identifier derived from an integer so re-fetches do not churn ids.
    init(deterministicFrom value: Int) {
        let hex = String(format: "%08x", value)
        self = UUID(uuidString: "00000000-0000-4000-8000-\(hex)0000") ?? UUID()
    }
}
