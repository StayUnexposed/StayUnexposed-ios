# StayUnexposed — iOS starter template

Company app template for **StayUnexposed**. A small but complete SwiftUI
starting point: MVVM structure, dependency
injection, a typed networking layer with a mock, a design-system folder, local
favourites persistence and unit + UI tests. Everything builds with **no third
party dependencies**.

## Requirements

- Xcode 16 or newer (the project uses `objectVersion = 77` with
  file-system-synchronized groups)
- iOS 17.0+ deployment target
- Swift 5 language mode

## Getting started

```sh
open StayUnexposed.xcodeproj
```

1. Pick the **StayUnexposed** scheme and an iPhone simulator.
2. In *Signing & Capabilities*, choose your team and change
   `PRODUCT_BUNDLE_IDENTIFIER` (currently `com.stayunexposed.StayUnexposed`).
3. Run with ⌘R. Tests run with ⌘U.

## Project layout

```
StayUnexposed/
├─ App/              App entry point, RootView tabs, AppDependencies (DI root)
├─ Core/
│  ├─ Models/        Domain models (Item)
│  ├─ Networking/    HTTPClient, Endpoint, APIError, ItemServing + mock
│  └─ Storage/       FavoritesStore (UserDefaults backed)
├─ DesignSystem/     Theme tokens and reusable views
├─ Features/
│  ├─ Home/          HomeView + HomeViewModel (list, search, pull-to-refresh)
│  ├─ Detail/        ItemDetailView
│  └─ Favorites/     FavoritesView
└─ Resources/        Assets.xcassets (AppIcon, AccentColor)
```

Files are picked up automatically, so adding a new file to a folder needs no
project edits.

## Architecture notes

- **DI root** — `AppDependencies` is created once and injected through the
  environment; features receive protocols, never concrete types.
- **State** — view models are `@MainActor @Observable` classes exposed through
  `@State`; views stay declarative and are unit tested without UI.
- **Networking** — `ItemServing` hides the transport. `MockItemService` is the
  default; swap `AppDependencies.live` to `RemoteItemService()` to hit
  `jsonplaceholder.typicode.com` instead.
- **Previews** use `AppDependencies.preview` with an isolated `UserDefaults`
  suite so preview data never leaks into the simulator store.

## Tests

- `StayUnexposedTests` — Swift Testing suites for `HomeViewModel` (search, error
  handling, idempotent loading) and `FavoritesStore` (toggle, persistence).
- `StayUnexposedUITests` — XCTest flows for opening a detail screen, favouriting an
  item and empty search state.

## Renaming the template

Rename the app in three places: the folder `StayUnexposed`, the `StayUnexposed`
target, and `PRODUCT_BUNDLE_IDENTIFIER`. Then update `CFBundleDisplayName`
(`INFOPLIST_KEY_CFBundleDisplayName`). The scheme file lives in
`StayUnexposed.xcodeproj/xcshareddata/xcschemes/`.

## Next steps worth adding

- String catalog (`Localizable.xcstrings`) once copy is final
- `SwiftData` or a sync layer to replace `FavoritesStore`
- CI workflow running `xcodebuild test -scheme StayUnexposed`

## Branding

| Setting | Value |
| --- | --- |
| Target / scheme / product | `StayUnexposed` |
| Bundle identifiers | `com.stayunexposed.StayUnexposed`, `…Tests`, `…UITests` |
| Display name | `StayUnexposed` (`INFOPLIST_KEY_CFBundleDisplayName`) |
| Copyright | `Copyright © 2026 StayUnexposed. All rights reserved.` |
| Preview storage suite | `com.stayunexposed.StayUnexposed.preview` |

Copyright © 2026 StayUnexposed. All rights reserved.
