# AppsView

`AppsView` is a simple SwiftUI view for displaying apps from the App Store in a similar UI/UX. Particularly useful for showing an app developer's other apps. This is a SwiftUI port of the original [DAAppsViewController](https://github.com/danielamitay/DAAppsViewController)

| By ArtistId | By List of AppIds | By Search Term |
|---|---|---|
| ![by artist id](https://github.com/danielamitay/AppsView/assets/647626/ddf561b7-b46e-4323-bb3f-c6db89f8efeb) | ![by list of app ids](https://github.com/danielamitay/AppsView/assets/647626/51e124a5-a7bc-483a-87c6-758faf2bab60) | ![by search term](https://github.com/danielamitay/AppsView/assets/647626/cae36211-7ae9-477d-ad2c-61255972dcf4) |

## Installation

Requires iOS 15+.

### Swift Package Manager

In Xcode go to Project -> Your Project Name -> `Package Dependencies` -> Tap *Plus*. Insert url:

```
https://github.com/danielamitay/AppsView
```

or adding it to the `dependencies` of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/danielamitay/AppsView.git", .upToNextMajor(from: "1.0.0"))
]
```

### Manually

If you prefer not to use any dependency managers, you can integrate manually. Put `Sources/AppsView` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Usage

#### Displaying apps by a specific developer (useful for "Our other apps")

```swift
AppsView(developerId: 356087517)
```

#### Displaying a predetermined set of apps

```swift
AppsView(appIds: [575647534, 498151501, 482453112, 582790430, 543421080])
```

#### Displaying apps for a specific App Store search term

```swift
AppsView(searchTerm: "Radio")
```
