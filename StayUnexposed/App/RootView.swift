import SwiftUI

struct RootView: View {
    @Environment(AppDependencies.self) private var dependencies

    var body: some View {
        TabView {
            NavigationStack {
                HomeView(service: dependencies.itemService)
            }
            .tabItem {
                Label("Home", systemImage: "square.grid.2x2")
            }

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
        }
    }
}

#Preview {
    RootView()
        .environment(AppDependencies.preview)
}
