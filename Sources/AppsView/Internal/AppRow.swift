//
//  SwiftUIView.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

internal struct AppRow: View {
    let app: String

    var body: some View {
        Text(app)
    }
}

#Preview {
    NavigationView {
        List {
            AppRow(app: "Test")
        }
        .navigationTitle("Apps")
        .listStyle(.plain)
    }
}
