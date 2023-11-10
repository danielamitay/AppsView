//
//  AppsView.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

public struct AppsView: View {
    private let request: iTunesAPI.Request
    private let options: AppsView.Options
    private let opened: ((_ appId: Int) -> Void)?
    @State private var state: LoadState = .unloaded

    public struct Options {
        var showIncompatibleApps: Bool = false
        var loadedTitle: String? = nil
    }

    private enum LoadState {
        case unloaded
        case loading
        case error(error: Error? = nil)
        case loaded(apps: [App], developerName: String?)
    }

    public init(developerId id: Int, options: AppsView.Options? = nil, opened: ((_ appId: Int) -> Void)? = nil) {
        self.request = .developerId(id)
        self.options = options ?? .init()
        self.opened = opened
    }

    public init(appIds ids: [Int], options: AppsView.Options? = nil, opened: ((_ appId: Int) -> Void)? = nil) {
        self.request = .appIds(ids)
        self.options = options ?? .init()
        self.opened = opened
    }

    public init(searchTerm term: String, options: AppsView.Options? = nil, opened: ((_ appId: Int) -> Void)? = nil) {
        self.request = .searchTerm(term)
        self.options = options ?? .init()
        self.opened = opened
    }

    public var body: some View {
        switch state {
        case .unloaded:
            LoadingView().onAppear {
                fetchApps()
            }
        case .loading:
            LoadingView()
        case .error(let error):
            ErrorView(error: error) {
                fetchApps()
            }
        case let .loaded(apps, developerName):
            LoadedView(
                apps: apps,
                navigationTitle: navigationTitle(developerName: developerName)
            ) { app in
                StoreModal.present(itunesId: app.trackId)
                opened?(app.trackId)
            }
        }
    }
}

// MARK: Internal logic
private extension AppsView {
    func fetchApps() {
        state = .loading
        iTunesAPI.lookup(request) { response in
            switch response {
            case .error(let error):
                state = .error(error: error)
            case let .success(softwares, artist):
                let apps = softwares.compactMap { software in
                    App(software: software)
                }.filter { app in
                    return (options.showIncompatibleApps || app.isCompatible) && !app.isCurrentApp
                }
                state = .loaded(apps: apps, developerName: artist?.artistName)
            }
        }
    }

    func navigationTitle(developerName: String?) -> String? {
        if let titleOverride = options.loadedTitle {
            return titleOverride
        }
        switch request {
        case .developerId(_):
            return developerName
        case .appIds(_):
            return nil
        case .searchTerm(let term):
            return term
        }
    }
}

#Preview {
    NavigationView {
        List {
            // By Developer Id
            Section("By Developer Id") {
                ForEach([
                    ("Daniel Amitay", 356087517),
                    ("Apple", 284417353),
                    ("Meta", 284882218),
                    ("Google", 281956209),
                ], id: \.0) { item in
                    NavigationLink(item.0) {
                        AppsView(developerId: item.1)
                    }
                }
            }
            // By App Ids
            Section("By App Ids") {
                ForEach([
                    ("Social Apps", [447188370, 835599320, 333903271, 6446901002, 284882215, 389801252, 288429040, 310633997]),
                    ("Slick Apps", [401626263, 363590051, 963034692, 498151501, 582790430, 493136154]),
                    ("Cool Tech", [284993459, 383463868, 377342622, 489321253]),
                ], id: \.0) { item in
                    NavigationLink(item.0) {
                        AppsView(appIds: item.1, options: .init(loadedTitle: item.0))
                    }
                }
            }
            // By Search Term
            Section("By Search Term") {
                ForEach([
                    "Angry",
                    "Sleep",
                    "Radio"
                ], id: \.self) { item in
                    NavigationLink(item) {
                        AppsView(searchTerm: item)
                    }
                }
            }
        }
        .navigationTitle("AppsView")
        .listStyle(.plain)
    }
}
