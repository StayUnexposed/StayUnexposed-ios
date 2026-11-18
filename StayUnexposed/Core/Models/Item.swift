import Foundation

/// Domain model shared by the list and the detail screens.
struct Item: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    let title: String
    let subtitle: String
    let body: String
    let category: Category
    let rating: Double

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        body: String,
        category: Category,
        rating: Double
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.category = category
        self.rating = rating
    }
}

extension Item {
    enum Category: String, Codable, CaseIterable, Sendable {
        case engineering
        case design
        case productivity
        case lifestyle

        var title: String {
            rawValue.capitalized
        }

        var symbolName: String {
            switch self {
            case .engineering: "hammer"
            case .design: "paintpalette"
            case .productivity: "checklist"
            case .lifestyle: "leaf"
            }
        }
    }
}

extension Item {
    /// Deterministic data used by the mock service, previews and tests.
    static let samples: [Item] = [
        Item(
            title: "Ship a weekly build",
            subtitle: "Release train · Every Thursday",
            body: "Automate the archive, run the UI smoke tests and upload the build before lunch. Keep the release notes short and honest.",
            category: .engineering,
            rating: 4.8
        ),
        Item(
            title: "Name the design tokens",
            subtitle: "Design system · Foundation",
            body: "Colour, spacing and radius values belong in one file so the whole team reads the same vocabulary.",
            category: .design,
            rating: 4.6
        ),
        Item(
            title: "Protect focus hours",
            subtitle: "Calendar · 09:00 – 11:00",
            body: "Two uninterrupted hours beat an afternoon of context switching. Decline meetings that fit inside the block.",
            category: .productivity,
            rating: 4.9
        ),
        Item(
            title: "Walk after lunch",
            subtitle: "Routine · 20 minutes",
            body: "A short walk resets attention for the second half of the day and keeps the afternoon slump at bay.",
            category: .lifestyle,
            rating: 4.4
        ),
        Item(
            title: "Write the failing test first",
            subtitle: "Practice · Red, green, refactor",
            body: "A test that fails for the right reason proves the harness works and pins the behaviour you are about to add.",
            category: .engineering,
            rating: 4.7
        ),
        Item(
            title: "Audit the empty states",
            subtitle: "UX review · Onboarding",
            body: "Every list, chart and search result needs a calm explanation of why it is empty and what to do next.",
            category: .design,
            rating: 4.3
        )
    ]
}
