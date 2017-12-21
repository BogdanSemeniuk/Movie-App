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
    
    var allImages: Images? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    private let offset: CGFloat = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allImages?.backdrops.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        guard let imagePath = allImages?.backdrops[indexPath.section].filePath else {return UICollectionViewCell()}
        let url = createBackdropURL(path: imagePath)
        print(url?.absoluteString)
//        if indexPath.section % 2 == 0 {
//            cell.backgroundColor = UIColor.red
//        } else {
//            cell.backgroundColor = UIColor.blue
//        }
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
