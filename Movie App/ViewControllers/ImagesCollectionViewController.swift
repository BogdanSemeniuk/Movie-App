//
//  ImagesCollectionViewController.swift
//  Movie App
//
//  Created by Богдан Семенюк on 20.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class ImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var postersAndBackdrops: Images? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    var allImages: [Image] {
        guard let postersAndBackdrops = postersAndBackdrops  else {return [Image]()}
        let backdrops = postersAndBackdrops.backdrops as [Image]
        let posters = postersAndBackdrops.posters as [Image]
        return backdrops + posters
    }
    
    
    private let offset: CGFloat = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        let path = allImages[indexPath.section].filePath
        let url = createBackdropURL(path: path)

        cell.imageView.kf.setImage(with: url)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = collectionView.bounds.size.width
        return CGSize(width: width, height: height)
    }
}
