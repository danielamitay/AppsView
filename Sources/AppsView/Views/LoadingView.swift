//
//  LoadingView.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

internal struct LoadingView: View {
    var body: some View {
        HStack(spacing: 10) {
            ProgressView()
                .tint(.secondary)
            Text("Loading...")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Loading...")
    }
}

#Preview {
    NavigationView {
        LoadingView()
    }
}
