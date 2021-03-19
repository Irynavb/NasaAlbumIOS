//
//  ImagesCollectionViewController.swift
//  NasaAlbumIOS
//
//  Created by Iryna Betancourt on 3/15/21.
//

import UIKit

class ImagesCollectionViewController: DataLoadingViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private lazy var layout = UICollectionViewFlowLayout()
    
    // initialize to get the data from api to  present in UI
    var images: [Item] = []
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // call to get the images from api
        getImagesForCollectionView(for: page)
    }
    
    func presentAlert(error: String) {
        let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func getImagesForCollectionView(for page: Int) {
        showLoadingView()
        ApiClient.shared.getImages(page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let images):
                guard let images = images?.collection.items else { return }
                // present on the main thread
                DispatchQueue.main.async {
                    if page == 1 {
                        self.images.removeAll()
                        self.images = images
                    } else {
                        // add images from next pages
                        self.images.append(contentsOf: images)
                    }
                    // reload after getting the data from api
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(error: "Seems like something went wrong. Error Occured: \(error)")
                }
            }
        }
    }
    
    private func configureCollectionView() {
        // collection view layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        
        // set collection view delegate
        collectionView.delegate = self
        
        // set dataSource
        collectionView.dataSource = self
        
        // cells grid layout set up
        layout.sectionInset = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        layout.minimumLineSpacing = 13
        layout.minimumInteritemSpacing = 13
    }
}

extension ImagesCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // will return 100 without pagination
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell

        cell.backgroundColor = .systemBackground
        
        let image = images[indexPath.item]
        
        cell.configureTitle(with: images[indexPath.item])
        
        cell.set(image: image)
        
        return cell
        
    }
}

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // set up the 2 column layout and cell size
        let screenSize = UIScreen.main.bounds
        _ = screenSize.width

        let cellWidth = (collectionView.bounds.size.width - (layout.sectionInset.left + layout.sectionInset.right + layout.minimumLineSpacing))/2
        let cellHeight = cellWidth

        return CGSize.init(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // push the single image controller after tapping on image
        let image = images[indexPath.item]
        // navigation controller for singleImageViewController
        let rootVC = SingleImageViewController(item: image)
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.title = "Image Details"
        present(navVC, animated: true)
    }
}

extension ImagesCollectionViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            page += 1
            getImagesForCollectionView(for: page)
        }
    }
}
