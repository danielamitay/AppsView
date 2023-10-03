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
    let averageUserRating: Float?
    let userRatingCount: Int?
}

// MARK: Helper initializer
internal extension App {
    init(trackId: Int, trackName: String, genres: [String], artworkUrl512: String?, formattedPrice: String? = nil) {
        self.init(
            trackId: trackId,
            trackName: trackName,
            genres: genres,
            artistId: nil,
            bundleId: nil,
            formattedPrice: formattedPrice,
            screenshotUrls: nil,
            ipadScreenshotUrls: nil,
            features: nil,
            minimumOsVersion: nil,
            artworkUrl100: nil,
            artworkUrl512: artworkUrl512,
            averageUserRating: nil,
            userRatingCount: nil
        )
    }
}

// MARK: Helper methods
internal extension App {
    var isCompatible: Bool {
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
