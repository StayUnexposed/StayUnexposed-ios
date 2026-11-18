import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    enum Phase: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    private let service: ItemServing

    private(set) var items: [Item] = []
    private(set) var phase: Phase = .idle
    var searchText = ""

    init(service: ItemServing) {
        self.service = service
    }

    var visibleItems: [Item] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return items }

        return items.filter { item in
            item.title.localizedCaseInsensitiveContains(query)
                || item.subtitle.localizedCaseInsensitiveContains(query)
                || item.category.title.localizedCaseInsensitiveContains(query)
        }
    }

    func loadIfNeeded() async {
        guard phase == .idle else { return }
        await reload()
    }

    func reload() async {
        phase = .loading
        do {
            items = try await service.fetchItems()
            phase = .loaded
        } catch is CancellationError {
            // A cancelled task keeps whatever was on screen; re-arm loading when
            // nothing had been shown yet so the next appearance retries.
            phase = items.isEmpty ? .idle : .loaded
        } catch {
            items = []
            phase = .failed(error.localizedDescription)
        }
    }
}
