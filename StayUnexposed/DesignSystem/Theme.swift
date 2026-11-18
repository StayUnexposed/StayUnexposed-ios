import SwiftUI

/// Centralised design tokens. Keep raw numbers out of feature views.
enum Theme {
    enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
    }

    static let cornerRadius: CGFloat = 14
    static let rowSpacing: CGFloat = 6
}
