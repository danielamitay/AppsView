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
        let results: [ResultDto]
    }
    enum ResultDto: Decodable {
        case software(SoftwareDto)
        case artist(ArtistDto)
        case unknown

        init(from decoder: Decoder) throws {
            if let software = try? SoftwareDto(from: decoder) {
                self = .software(software)
                return
            }
            if let artist = try? ArtistDto(from: decoder) {
                self = .artist(artist)
                return
            }
            self = .unknown
        }
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
                do {
                    let resultsDto = try JSONDecoder().decode(ResultsDto.self, from: data)
                    let finalResult = softwareAndArtistForResults(results: resultsDto)
                    safeCompletion(.success(finalResult.0, finalResult.1))
                } catch {
                    safeCompletion(.error(error))
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

    static func softwareAndArtistForResults(results: ResultsDto) -> ([SoftwareDto], ArtistDto?) {
        var artist: ArtistDto? = nil
        var softwares: [SoftwareDto] = []
        for result in results.results {
            switch result {
            case .software(let softwareDto):
                softwares.append(softwareDto)
            case .artist(let artistDto):
                if artist == nil {
                    artist = artistDto
                }
            case .unknown:
                break
            }
        }
        return (softwares, artist)
    }
}
