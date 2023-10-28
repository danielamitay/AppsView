//
//  AppRow.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

internal struct AppRow: View {
    let app: App
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Color.init(uiColor: .tertiarySystemGroupedBackground)
                    .cornerRadius(11)
                CachedAsyncImage(url: app.iconURL) { phase in
                    switch phase {
                    case .empty:
                        EmptyView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                    @unknown default:
                        EmptyView()
                    }
                }
                RoundedRectangle(cornerRadius: 11)
                    .stroke(Color(uiColor: .init(white: 0.5, alpha: 0.1)), lineWidth: 1)

            }
            .frame(width: 64, height: 64)
            .cornerRadius(11)

            VStack(alignment: .leading, spacing: 3) {
                Text(app.trackName)
                    .lineLimit(2)
                    .font(.system(size: 16))
                    .foregroundColor(.init(uiColor: .label))
                if let genre = app.genres.first {
                    Text(genre)
                        .lineLimit(1)
                        .font(.system(size: 13))
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                }
            }

            Spacer()

            Button(action: action) {
                Text(app.formattedPrice?.uppercased() ?? "VIEW")
                    .frame(width: 72, height: 28)
                    .background(Color.init(uiColor: .init(white: 0.75, alpha: 0.2)))
                    .foregroundColor(.blue)
                    .font(.system(size: 14, weight: .bold))
                    .cornerRadius(14)
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationView {
        List {
            AppRow(app: .iTrackMail) {}
            AppRow(app: .WifiCamera) {}
        }
        .navigationTitle("Apps")
        .listStyle(.plain)
    }
}
#endif
