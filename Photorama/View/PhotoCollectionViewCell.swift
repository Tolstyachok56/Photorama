//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Виктория Бадисова on 07.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spiner: UIActivityIndicatorView!
    
    var photoDescription: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
    
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spiner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spiner.startAnimating()
            imageView.image = nil
        }
    }
    
    override var isAccessibilityElement: Bool {
        get { return true }
        set { super.isAccessibilityElement = newValue }
    }
    
    override var accessibilityLabel: String? {
        get { return photoDescription }
        set {}
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get { return super.accessibilityTraits | UIAccessibilityTraitImage }
        set {}
    }
    
}
