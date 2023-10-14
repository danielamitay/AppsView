//
//  iTunesAPI.swift
//  AppsView
//
//  Created by Daniel Amitay on 10/3/23.
//

import Foundation
import SwiftyJSON

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
        let results: [JSON]
    }
    struct SoftwareDto: Decodable {
        let trackId: Int
        let trackName: String
        let kind: String
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
        let safeCompletion: (Response) -> Void = { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
        let requestPath = pathForRequest(request)
        var urlComponents = URLComponents(string: "https://itunes.apple.com/\(requestPath)")!
        var queryItems = urlComponents.queryItems ?? .init()
        queryItems.append(.init(name: "entity", value: "software"))
        if #available(iOS 16.0, *) {
            queryItems.append(.init(name: "country", value: Locale.current.region?.identifier))
            queryItems.append(.init(name: "l", value: Locale.current.language.languageCode?.identifier))
        } else {
            queryItems.append(.init(name: "country", value: Locale.current.regionCode))
            queryItems.append(.init(name: "l", value: Locale.current.languageCode))
        }
        urlComponents.queryItems = queryItems
        guard let requestURL = urlComponents.url else {
            safeCompletion(.error(nil))
            return
        }
        let urlRequest = URLRequest(url: requestURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data {
                let resultsPair = flatDecode(data: data, type: ResultsDto.self)
                if let resultsDto = resultsPair.0 {
                    let finalResult = softwareAndArtistForResults(results: resultsDto)
                    safeCompletion(.success(finalResult.0, finalResult.1))
                } else {
                    safeCompletion(.error(resultsPair.1))
                }
            } else {
                safeCompletion(.error(error))
            }
        }.resume()
    }
}

// MARK: Private methods
private extension iTunesAPI {
    static func pathForRequest(_ request: Request) -> String {
        switch request {
        case .developerId(let id):
            return "lookup?id=\(id)"
        case .appIds(let ids):
            let appsString = ids.map { String($0) }.joined(separator: ",")
            return "lookup?id=\(appsString)"
        case .searchTerm(let term):
            let escapedTerm = term.addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines.inverted)
            return "search?term=\(escapedTerm ?? term)"
        }
    }

    static func flatDecode<T: Decodable>(data: Data, type: T.Type) -> (T?, Error?) {
        var decodedObject: T?
        var decodeError: Error?
        do {
            decodedObject = try JSONDecoder().decode(T.self, from: data)
        } catch {
            decodeError = error
        }
        return (decodedObject, decodeError)
    }

    static func softwareAndArtistForResults(results: ResultsDto) -> ([SoftwareDto], ArtistDto?) {
        var artist: ArtistDto?
        var softwares = [SoftwareDto]()
        for result in results.results {
            let data = try? result.rawData()
            guard let data else { continue }
            if let softwareDto = flatDecode(data: data, type: SoftwareDto.self).0 {
                softwares.append(softwareDto)
            } else if artist == nil, let artistDto = flatDecode(data: data, type: ArtistDto.self).0 {
                artist = artistDto
            }
        }
        return (softwares, artist)
    }
}
