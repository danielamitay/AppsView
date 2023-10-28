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
    let action: (App) -> Void

    var body: some View {
        if apps.isEmpty {
            Text("No Results")
                .font(.system(size: 28, weight: .bold))
                .navigationTitle(navigationTitle ?? "Results")
        } else {
            List(apps, id: \.trackId) { app in
                AppRow(app: app) {
                    action(app)
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
        ], navigationTitle: "Daniel Amitay") { _ in }
    }
}
#endif
