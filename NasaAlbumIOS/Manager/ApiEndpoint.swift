//
//  ApiEndpoint.swift
//  NasaAlbumIOS
//
//  Created by Iryna Betancourt on 3/15/21.
//

import Foundation

struct ApiEndpoint {
    
    // apiEndpoint configuration without pagination implemented
    var path: String
    var queryItems: [URLQueryItem] = []

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "images-api.nasa.gov"
        components.path = "/" + self.path
        components.queryItems = self.queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL \(components)")
        }

        return url
    }

    // for specific url
    static func fetchImages(page: Int) -> Self {
        let query: [URLQueryItem] = [URLQueryItem(name: "q", value: ""),
                                     URLQueryItem(name: "media_type", value: "image"),
                                     URLQueryItem(name: "year_start", value: "2021"),
                                     URLQueryItem(name: "page", value: "\(page)")]
        let path = "search"

        return ApiEndpoint(path: path, queryItems: query)
    }
}
