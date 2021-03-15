//
//  ImageTitleLabel.swift
//  NasaAlbumIOS
//
//  Created by Iryna Betancourt on 3/15/21.
//

import UIKit

class ImageTitleLabel: UILabel {
    
    // used for cell's title and single image's title
    override init(frame:  CGRect) {
        super.init(frame: frame)
        configure()
    }

    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }

    private func configure() {
        textColor = .label
        textAlignment = .left
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
