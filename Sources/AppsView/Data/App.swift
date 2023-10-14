//
//  App.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/2/23.
//

import Foundation
import UIKit

internal struct App {
    let trackId: Int
    let trackName: String
    let kind: String
    let genres: [String]
    let artistId: Int?
    let bundleId: String?
    let formattedPrice: String?
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let features: [String]?
    let minimumOsVersion: String?
    let artworkUrl100: String?
    let artworkUrl512: String?
}

// MARK: Helper initializers
extension App {
    init(software: iTunesAPI.SoftwareDto) {
        self.init(
            trackId: software.trackId,
            trackName: software.trackName,
            kind: software.kind,
            genres: software.genres,
            artistId: software.artistId,
            bundleId: software.bundleId,
            formattedPrice: software.formattedPrice,
            screenshotUrls: software.screenshotUrls,
            ipadScreenshotUrls: software.ipadScreenshotUrls,
            features: software.features,
            minimumOsVersion: software.minimumOsVersion,
            artworkUrl100: software.artworkUrl100,
            artworkUrl512: software.artworkUrl512
        )
    }
}

// MARK: Helper methods
extension App {
    var isCompatible: Bool {
        guard kind == "software" else { return false }
        let systemVersion = UIDevice.current.systemVersion
        if let minimumOsVersion, minimumOsVersion.compare(systemVersion, options: .numeric) != .orderedDescending {
            if features?.contains(where: { feature in
                feature == "iosUniversal"
            }) == true {
                // App is universally compatible
                return true
            } else {
                switch UIDevice.current.userInterfaceIdiom {
                case .phone:
                    // App is only compatible with iPhone if it contains screenshot urls
                    return screenshotUrls?.count ?? 0 > 0
                case .pad:
                    // App is only compatible with iPad if it contains screenshot urls or ipad screenshot urls
                    return screenshotUrls?.count ?? 0 > 0 || ipadScreenshotUrls?.count ?? 0 > 0
                default:
                    return false
                }
            }
        }
        return false
    }
    var iconURL: URL? {
        if let artworkUrl512 {
            return URL(string: artworkUrl512)
        }
        if let artworkUrl100 {
            return URL(string: artworkUrl100)
        }
        return nil
    }
}

#if DEBUG
// MARK: Convenience initializers for #Previews
extension App {
    static var iTrackMail: App {
        App(trackId: 533886215, trackName: "iTrackMail - Email Tracking", genres: ["Productivity"], artworkUrl512: "https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/f5/dd/b8/f5ddb85d-79e1-111c-a8a3-874a16963f08/AppIcon-0-0-1x_U007emarketing-0-6-0-85-220.png/512x512bb.jpg", formattedPrice: "Free")
    }
    static var WifiCamera: App {
        App(trackId: 374351996, trackName: "WiFi Camera - Remote iPhones", genres: ["Photo & Video"], artworkUrl512: "https://is1-ssl.mzstatic.com/image/thumb/Purple113/v4/81/a0/20/81a02039-0da9-1c74-7d1e-1b319fb9d1a0/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-85-220.png/512x512bb.jpg", formattedPrice: "$1.99")
    }
    init(trackId: Int, trackName: String, genres: [String], artworkUrl512: String?, formattedPrice: String? = nil) {
        self.init(
            trackId: trackId,
            trackName: trackName,
            kind: "software",
            genres: genres,
            artistId: nil,
            bundleId: nil,
            formattedPrice: formattedPrice,
            screenshotUrls: nil,
            ipadScreenshotUrls: nil,
            features: nil,
            minimumOsVersion: nil,
            artworkUrl100: nil,
            artworkUrl512: artworkUrl512
        )
    }
}
#endif
