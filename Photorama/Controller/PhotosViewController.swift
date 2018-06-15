//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Виктория Бадисова on 06.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        updateDataSource()
        
        store.fetchInterestingPhotos { (photosResult) in
            self.updateDataSource()
        }
    }
    
    //MARK: - UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        store.fetchImage(for: photo) { (result) in
            
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else { return }
            
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destination = segue.destination as! PhotoInfoViewController
                destination.photo = photo
                destination.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    //MARK: - Update collection view data source
    
    private func updateDataSource() {
        store.fetchAllPhotos { (photosResult) in
            
            switch photosResult {
            case let .success(photos):
                if self.segmentedControl.selectedSegmentIndex == 0 {
                    self.photoDataSource.photos = photos
                } else {
                    self.photoDataSource.photos = photos.filter { $0.favorite }
                }
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    //MARK: - Actions
    
    @IBAction func switchPhotoFilter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
}
