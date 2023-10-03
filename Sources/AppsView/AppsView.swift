//
//  AppsView.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

public struct AppsView: View {
    public var body: some View {
        LoadedView(apps: ["One", "Two", "Three"])
    }
}

#Preview {
    NavigationView {
        AppsView()
    }
}
