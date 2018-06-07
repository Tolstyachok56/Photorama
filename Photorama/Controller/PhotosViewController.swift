//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Виктория Бадисова on 06.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        
        store.fetchInterestingPhotos { (photoResult) in
            switch photoResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
}
