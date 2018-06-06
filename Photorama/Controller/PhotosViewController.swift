//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Виктория Бадисова on 06.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentedControl = UISegmentedControl(items: ["Interesting", "Recent"])
        segmentedControl.addTarget(self, action: #selector(fetchPhoto), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
    }
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) { (imageResult) in
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
    
    @objc func fetchPhoto(_ sender: UISegmentedControl) {
        let method: Method = sender.selectedSegmentIndex == 0 ? .interestingPhotos : .recentPhotos
        
        store.fetchPhotos(for: method) { (photoResult) in
            switch photoResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
    
}
