//
//  SwiftUIView.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

internal struct LoadedView: View {
    let apps: [String]

    var body: some View {
        if apps.isEmpty {
            Text("No Results")
                .font(.system(size: 28, weight: .bold))
                .navigationTitle("Results")
        } else {
            List(apps, id: \.self) { app in
                AppRow(app: app)
            }
            .navigationTitle("Results")
        }
    }
}

#Preview {
    NavigationView {
        LoadedView(apps: ["One", "Two", "Three"])
    }
}
