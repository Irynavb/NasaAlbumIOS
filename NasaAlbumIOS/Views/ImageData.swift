//
//  ImageData.swift
//  NasaAlbumIOS
//
//  Created by Iryna V Betancourt on 3/22/21.
//

import UIKit

extension  SingleImageViewController {

    private func getImageTitle() -> String {
        item.data[0].title ?? "Unknown Image Title"
    }

    private func getImageLocation() -> String {
        "Location: \(item.data[0].location ?? "Unknown")"
    }

    private func getImagePhotographer() -> String {
        "Photographer: \(item.data[0].photographer ?? "Unknown")"
    }

    private func getImageDescription() -> String {
        item.data[0].datumDescription ?? ""
    }
}
