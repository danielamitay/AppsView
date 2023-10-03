//
//  ErrorView.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

internal struct ErrorView: View {
    let error: Error?
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                Text("Error Loading Apps")
            }
            .font(.system(size: 18, weight: .semibold))

            if let error {
                Text(error.localizedDescription)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 14))
            }

            Button(action: retry) {
                Text("Retry")
                    .padding(.init(top: 10, leading: 40, bottom: 10, trailing: 40))
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .navigationTitle("Error")
    }
}

#Preview {
    NavigationView {
        ErrorView(error: nil) {
            // no-op
        }
    }
}
