import Foundation
import Testing

@testable import StayUnexposed

@MainActor
struct HomeViewModelTests {
    private func makeModel(service: ItemServing) -> HomeViewModel {
        HomeViewModel(service: service)
    }

    @Test("Loading populates the list and finishes in the loaded phase")
    func loadPopulatesItems() async {
        let model = makeModel(service: MockItemService(latency: .zero))

        await model.loadIfNeeded()

        #expect(model.phase == .loaded)
        #expect(model.items.count == Item.samples.count)
    }

    @Test("loadIfNeeded only fetches once")
    func loadIfNeededIsIdempotent() async {
        let service = CountingItemService()
        let model = makeModel(service: service)

        await model.loadIfNeeded()
        await model.loadIfNeeded()

        #expect(service.callCount == 1)
    }

    @Test("Search matches title, subtitle and category")
    func searchFiltersItems() async {
        let model = makeModel(service: MockItemService(latency: .zero))
        await model.loadIfNeeded()

        model.searchText = "walk"
        #expect(model.visibleItems.count == 1)

        model.searchText = "engineering"
        #expect(model.visibleItems.allSatisfy { $0.category == .engineering })

        model.searchText = "  "
        #expect(model.visibleItems.count == model.items.count)
    }

    @Test("A failure surfaces an error message and clears the items")
    func failureSetsFailedPhase() async {
        let model = makeModel(service: FailingItemService(error: .statusCode(500)))

        await model.reload()

        guard case .failed(let message) = model.phase else {
            Issue.record("Expected a failed phase, got \(model.phase)")
            return
        }
        #expect(message.contains("500"))
        #expect(model.items.isEmpty)
    }
}

private final class CountingItemService: ItemServing, @unchecked Sendable {
    private(set) var callCount = 0

    func fetchItems() async throws -> [Item] {
        callCount += 1
        return Item.samples
    }
}
