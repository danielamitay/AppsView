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
    let supportedDevices: [String]?
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
            supportedDevices: software.supportedDevices,
            minimumOsVersion: software.minimumOsVersion,
            artworkUrl100: software.artworkUrl100,
            artworkUrl512: software.artworkUrl512
        )
    }
}

// MARK: Helper methods
extension App {
    var isCurrentApp: Bool {
        if let hostAppBundleId = Bundle.main.bundleIdentifier, let bundleId {
            return hostAppBundleId == bundleId
        }
        return false
    }
    var isCompatible: Bool {
        // Make sure the app is actually software
        guard kind == "software" else { return false }

        // Make sure the app is compatible with the current OS version
        let systemVersion = UIDevice.current.systemVersion
        if let minimumOsVersion, minimumOsVersion.compare(systemVersion, options: .numeric) == .orderedDescending {
            return false
        }

        // If the features contain "iosUniversal", the app is universally compatible
        if features?.contains(where: { $0 == "iosUniversal" }) == true {
            // App is universally compatible
            return true
        }

        // Perform device-specific compatibility checks
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // App is only compatible with iPhone if it contains screenshot urls
            // or there are more than 5 supported "iPhone" devices
            let filteredDevices = supportedDevices?.filter { $0.lowercased().hasPrefix("iphone") }
            return (screenshotUrls?.count ?? 0 > 0 || filteredDevices?.count ?? 0 > 5)
        case .pad:
            // App is only compatible with iPad if it contains screenshot urls or ipad screenshot urls
            // or there are more than 5 supported "iPad" devices
            let filteredDevices = supportedDevices?.filter { $0.lowercased().hasPrefix("ipad") }
            return (screenshotUrls?.count ?? 0 > 0 || ipadScreenshotUrls?.count ?? 0 > 0 || filteredDevices?.count ?? 0 > 5)
        default:
            // App is not compatible with other device types
            return false
        }
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
            supportedDevices: nil,
            minimumOsVersion: nil,
            artworkUrl100: nil,
            artworkUrl512: artworkUrl512
        )
    }
}
#endif
