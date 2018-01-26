//
//  ImagesViewController.swift
//  Movie App
//
//  Created by Bogdan on 25.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import Kingfisher

class ImagesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var leftArrowImageView: UIImageView!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    
    // MARK: - Properties
    
    private let reuseIdentifier = "Cell"
    var postersAndBackdrops: Images? {
        didSet {
            imagesCollectionView?.reloadData()
        }
    }
    var allImages: [Image] {
        guard let postersAndBackdrops = postersAndBackdrops  else {return [Image]()}
        let backdrops = postersAndBackdrops.backdrops as [Image]
        let posters = postersAndBackdrops.posters as [Image]
        let images = backdrops + posters
        if images.count == 1 {
            rightArrowImageView.alpha = 0.0
        }
        return images
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftArrowImageView.backgroundColor = UIColor.clear
        rightArrowImageView.backgroundColor = UIColor.clear
        leftArrowImageView.alpha = 0.0
    }
    
    // MARK: - UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        let path = allImages[indexPath.section].filePath
        let url = createBackdropURL(path: path)
        
        cell.imageView.kf.setImage(with: url)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = collectionView.bounds.size.width
        return CGSize(width: width, height: height)
    }
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView.contentOffset.x {
        case 0.0:
            leftArrowImageView.alpha = 0.0
        case scrollView.contentSize.width - imagesCollectionView.bounds.size.width:
            rightArrowImageView.alpha = 0.0
        default:
            rightArrowImageView.alpha = 0.6
            leftArrowImageView.alpha = 0.6
        }
    }
}
