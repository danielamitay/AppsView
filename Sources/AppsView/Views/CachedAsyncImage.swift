//
//  CachedAsyncImage.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/4/23.
//

import SwiftUI

internal struct CachedAsyncImage<Content>: View where Content: View {
    let url: URL?
    @ViewBuilder let content: (AsyncImagePhase) -> Content

    var body: some View {
        if let url, let cachedImage = Cache.images[url] {
            content(.success(cachedImage))
        } else {
            AsyncImage(
                url: url
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase, let url {
            Cache.images[url] = image
        }
        return content(phase)
    }
}

fileprivate class Cache {
    static var images: [URL: Image] = [:]
}
