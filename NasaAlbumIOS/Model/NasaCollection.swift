//
//  NasaCollection.swift
//  NasaAlbumIOS
//
//  Created by Iryna Betancourt on 3/15/21.
//

import Foundation

// model: [String: String] relationships
struct NasaCollection: Codable {
    let collection: Collection
}

struct Collection: Codable {
    let href: String
    let items: [Item]
    let version: String
    let links: [CollectionLink]
}

struct Item: Codable {
    var href: String
    var links: [ItemLink]
    var data: [Datum]
}

struct Datum: Codable {
    let dateCreated: String?
    let datumDescription: String?
    let title: String?
    let keywords: [String]?
    let location: String?
    let mediaType: MediaType?
    let photographer: String?
    let description508: String?

    enum CodingKeys: String, CodingKey {
        case dateCreated = "date_created"
        case datumDescription = "description"
        case title, keywords, location
        case mediaType = "media_type"
        case photographer
        case description508 = "description_508"
    }
}

enum MediaType: String, Codable {
    case image = "image"
}

struct ItemLink: Codable {
    let href: String
    let render: MediaType
}

struct CollectionLink: Codable {
    let href: String
}
