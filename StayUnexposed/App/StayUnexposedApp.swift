import SwiftUI

@main
struct StayUnexposedApp: App {
    @State private var dependencies: AppDependencies

    @MainActor
    init() {
        _dependencies = State(initialValue: .live)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(dependencies)
        }
    }
}
