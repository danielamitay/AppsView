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
        AppsView(developerId: 356087517)
    }
}
