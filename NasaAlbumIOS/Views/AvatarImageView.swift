//
//  AvatarImageView.swift
//  NasaAlbumIOS
//
//  Created by Iryna Betancourt on 3/15/21.
//

import UIKit

class AvatarImageView: UIImageView {
    
    // downloaded image from the API through ApiClient for this imageView
    let cache = ApiClient.shared.cache
    let placeholderImage = #imageLiteral(resourceName: "NASA-Logo-Placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = #imageLiteral(resourceName: "NASA-Logo-Placeholder")
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func downloadUserImage(fromURL url: String) {
        ApiClient.shared.downloadImage(from: url)  { [weak self] image in
            guard let self = self else { return }
            //show the image on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
