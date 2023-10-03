//
//  iTunesAPI.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/3/23.
//

import Foundation

internal struct iTunesAPI {
    enum Request {
        case developerId(Int)
        case appIds([Int])
        case searchTerm(String)
    }
    enum Response {
        case error(Error?)
        case success([SoftwareDto], ArtistDto?)
    }
    struct ResultsDto: Decodable {
        let resultCount: Int
        // TODO: Need arbitrary JSON
        let results: [String]
    }
    struct SoftwareDto: Decodable {
        let trackId: Int
        let trackName: String
        let artistId: Int
        let genres: [String]
        let bundleId: String
        let formattedPrice: String?
        let screenshotUrls: [String]?
        let ipadScreenshotUrls: [String]?
        let features: [String]?
        let minimumOsVersion: String?
        let artworkUrl100: String?
        let artworkUrl512: String?
    }
    struct ArtistDto: Decodable {
        let artistName: String
        let artistId: Int
    }
}

// MARK: Request methods
extension iTunesAPI {
    static func lookup(_ request: Request, completion: @escaping (Response) -> Void) {
        // TODO
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success([], nil))
        }
    }
}
