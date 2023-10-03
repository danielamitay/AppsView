//
//  AppRow.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import SwiftUI

internal struct AppRow: View {
    let app: App

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Color.init(uiColor: .tertiarySystemGroupedBackground)
                    .cornerRadius(11)
                AsyncImage(url: app.iconURL) { phase in
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
                    .stroke(Color.init(uiColor: .init(white: 0.5, alpha: 0.1)), lineWidth: 1)

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

            Button(action: {
                // TODO
            }) {
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

#Preview {
    NavigationView {
        List {
            AppRow(app: App(trackId: 533886215, trackName: "iTrackMail - Email Tracking", genres: ["Productivity"], artworkUrl512: "https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/f5/dd/b8/f5ddb85d-79e1-111c-a8a3-874a16963f08/AppIcon-0-0-1x_U007emarketing-0-6-0-85-220.png/512x512bb.jpg", formattedPrice: "Free"))
            AppRow(app: App(trackId: 374351996, trackName: "WiFi Camera - Remote iPhones", genres: ["Photo & Video"], artworkUrl512: "https://is1-ssl.mzstatic.com/image/thumb/Purple113/v4/81/a0/20/81a02039-0da9-1c74-7d1e-1b319fb9d1a0/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-85-220.png/512x512bb.jpg", formattedPrice: "$1.99"))
        }
        .navigationTitle("Apps")
        .listStyle(.plain)
    }
}
