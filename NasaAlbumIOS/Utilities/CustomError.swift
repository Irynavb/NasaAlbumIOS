//
//  CustomError.swift
//  NasaAlbumIOS
//
//  Created by Iryna Betancourt on 3/15/21.
//

import Foundation

enum CustomError: String, Error {
    
    // used mostly during the network call by ApiClient
    case badRequest = "This request was unacceptable, maybe there's a missing parameter."
    case notFound = "Unable to find the requested resource."
    case invalidServerResponse = "Invalid response from the server. Please try again."
    case parsingError = "There was a problem parsing the data. Try checking the data format."
}
