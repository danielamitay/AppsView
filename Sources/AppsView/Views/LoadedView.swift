//
//  LoadedView.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

internal struct LoadedView: View {
    let apps: [App]
    let navigationTitle: String?
    let action: (App, Action) -> Void

    enum Action {
        case view
        case share
    }

    var body: some View {
        if apps.isEmpty {
            Text("No Results")
                .font(.system(size: 28, weight: .bold))
                .navigationTitle(navigationTitle ?? "Results")
        } else {
            List(apps, id: \.trackId) { app in
                AppRow(app: app) {
                    action(app, .view)
                }
                .contextMenu {
                    Button {
                        action(app, .view)
                    } label: {
                        Text("View")
                        Image(systemName: "arrow.up.forward.app")
                    }
                    Button {
                        action(app, .share)
                    } label: {
                        Text("Share")
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(navigationTitle ?? "Results")
        }
    }
}

#if DEBUG
#Preview {
    NavigationView {
        LoadedView(apps: [
            .iTrackMail,
            .WifiCamera
        ], navigationTitle: "Daniel Amitay") { _, _ in }
    }
}
#endif
