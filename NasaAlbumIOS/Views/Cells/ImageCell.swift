//
//  ImageCell.swift
//  NasaAlbumIOS
//
//  Created by Iryna Betancourt on 3/15/21.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static let reuseID = "ImageCell"
    
    var avatarImageView = AvatarImageView(frame: .zero)
    let titleLabel = ImageTitleLabel(fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // set the image according to the model
    func set(image: Item) {
        avatarImageView.image = #imageLiteral(resourceName: "NASA-Logo-Placeholder")
        if image.links.count != 0 {
            let link = image.links[0]
            // call the ApiClient to download the image through its url
            ApiClient.shared.downloadImage(from: link.href) { (image) in
                if let downloadedImage = image {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = downloadedImage
                    }
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitle(with image: Item) {
        // `title` property from the model being assigned to titleLabel
        titleLabel.text = image.data[0].title
    }
    
    private func configure() {
        addSubviews(avatarImageView, titleLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            // avatarImageView constraints
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            // titleLabel constraints
            titleLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
