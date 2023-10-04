//
//  AppsView.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

public struct AppsView: View {
    private let request: iTunesAPI.Request
    @State private var state: LoadState = .unloaded

    private enum LoadState {
        case unloaded
        case loading
        case error(error: Error? = nil)
        case loaded(apps: [App], developerName: String?)
    }

    public init(developerId id: Int) {
        request = .developerId(id)
    }

    public init(appIds ids: [Int]) {
        request = .appIds(ids)
    }

    public init(searchTerm term: String) {
        request = .searchTerm(term)
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
            LoadedView(apps: apps, developerName: developerName)
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
                }
                state = .loaded(apps: apps, developerName: artist?.artistName)
            }
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
                        AppsView(appIds: item.1)
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
