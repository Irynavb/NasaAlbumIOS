//
//  SingleImageViewController.swift
//  NasaAlbumIOS
//
//  Created by Iryna Betancourt on 3/15/21.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let item: Item
    var imageTitleLabel = ImageTitleLabel(fontSize: 14)
    var avatarImageView = AvatarImageView(frame: .zero)
    let locationLabel = ImagePropertyLabel()
    let photographerLabel = ImagePropertyLabel()
    let descriptionLabel = ImagePropertyLabel()
    
    var itemViews: [UIView] = []
    
    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureScrollView()
        layoutUI()
    }
        
    func layoutUI() {
        let padding: CGFloat = 18
        
        itemViews = [imageTitleLabel, photographerLabel, locationLabel, avatarImageView, descriptionLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            // not to stretch the images
            avatarImageView.contentMode = .scaleAspectFit
            
            // same constraints for each of the itemViews
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        // other constraints for itemViews
        NSLayoutConstraint.activate([
            imageTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            photographerLabel.topAnchor.constraint(equalTo: imageTitleLabel.bottomAnchor, constant: padding),
            photographerLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.topAnchor.constraint(equalTo: photographerLabel.bottomAnchor, constant: padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            avatarImageView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 280),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: padding),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        
        descriptionLabel.numberOfLines = 0
    
        // button to dismiss singleImageViewController and go to the collection view
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        // configure data with the model
        imageTitleLabel.text = item.data[0].title ?? "Unknown Image Title"
        locationLabel.text = "Location: \(item.data[0].location ?? "Unknown")"
        photographerLabel.text = "Photographer: \(item.data[0].photographer ?? "Unknown")"
        descriptionLabel.text = item.data[0].datumDescription ?? ""

        if item.links.count != 0 {
            let link = item.links[0]
            ApiClient.shared.downloadImage(from: link.href) { (item) in
                if let downloadedImage = item {
                    // present on main thread
                    DispatchQueue.main.async {
                        self.avatarImageView.image = downloadedImage
                    }
                    
                }
            }
        }
    }
    
    func configureScrollView() {
        view.addSubviews(scrollView)
        scrollView.addSubview(contentView)
        // convenient method (view controller's extencion)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}
