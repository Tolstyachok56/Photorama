//
//  FlipbookLayout.swift
//  Photorama
//
//  Created by Виктория Бадисова on 07.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class FlipbookLayout: UICollectionViewLayout {
    
    private var photoWidth: CGFloat = 300
    private var photoHeight: CGFloat = 300
    private var numberOfPhotos: Int = 0
    private var currentPhoto: Int = 0
    
    override func prepare() {
        super.prepare()
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        numberOfPhotos = collectionView!.numberOfItems(inSection: 0)
        collectionView?.isPagingEnabled = true
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(numberOfPhotos) * collectionView!.bounds.size.width,
                      height: collectionView!.bounds.size.height)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array = [UICollectionViewLayoutAttributes]()
        
        if numberOfPhotos == 0 {
            return array
        }
        
        for i in 0...max(0, numberOfPhotos - 1) {
            let indexPath = IndexPath(item: i, section: 0)
            if let attributes = layoutAttributesForItem(at: indexPath) {
                array.append(attributes)
            }
        }
        return array
    }
    
//---------------------------------------------
    
    override func layoutAttributesForItem(at indexPath: IndexPath) ->UICollectionViewLayoutAttributes? {
        
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        var frame = getFrame(collectionView: collectionView!)
        if currentPhoto > indexPath.row {
            frame.origin.x -= photoWidth
        }
        layoutAttributes.frame = frame
        
        let ratio = getRatio(collectionView: collectionView!, indexPath: indexPath as NSIndexPath)
        
        let rotation = getRotation(indexPath: indexPath, ratio: ratio)
        layoutAttributes.transform3D = rotation
        
        // Not sure we need this
        if indexPath.row == 0 {
            layoutAttributes.zIndex = Int.max
        }
        
        layoutAttributes.zIndex = numberOfPhotos - indexPath.row
        
        return layoutAttributes
    }
    
    // MARK: - Attribute Logic Helpers
    
    func getFrame(collectionView: UICollectionView) -> CGRect {
        var frame = CGRect()
        
        // Modified
        
        
        frame.origin.x = collectionView.bounds.width - (photoWidth * 1.5) + collectionView.contentOffset.x
        
        
        frame.origin.y = (collectionViewContentSize.height - photoHeight) / 2
        
        photoWidth = collectionView.bounds.width
        photoHeight = photoWidth
        
        frame.size.width = photoWidth
        frame.size.height = photoHeight
        
        return frame
    }
    
    func getRatio(collectionView: UICollectionView, indexPath: NSIndexPath) -> CGFloat {
        // TO DO: we don't need to restrict our ratio between -0.5 and 0.5
        //        we can just have all the upcoming photos sitting flat (at 1.0)
        //        and all the flipped photos sitting flat off screen left (at -1.0)
        //        but I don't understand what this function does well enough to modify yet
        
        
        // Modified
        let page = CGFloat(indexPath.item)
        
        
        
        var ratio: CGFloat = -0.5 + page - (collectionView.contentOffset.x / collectionView.bounds.width)
        
        if ratio > 0.5 {
            ratio = 0.5 + 0.1 * (ratio - 0.5)
            
        } else if ratio < -0.5 {
            ratio = -0.5 + 0.1 * (ratio + 0.5)
        }
        
        
        //        print("--- in getRatio page \(page) ratio \(ratio) contentOffset.x \(collectionView.contentOffset.x)")
        
        currentPhoto = Int(collectionView.contentOffset.x / photoWidth)
        //        print("--- should see photo \(currentPhoto)")
        
        if indexPath.row == currentPhoto {
            ratio = (((CGFloat(currentPhoto) + 1) * photoWidth) - collectionView.contentOffset.x) / photoWidth
            print("+++ Ratio for currentPhoto \(ratio)")
        } else if indexPath.row > currentPhoto {
            ratio = 1.0
        } else {
            ratio = -1.0
        }
        
        return ratio
    }
    
    func getAngle(indexPath: IndexPath, ratio: CGFloat) -> CGFloat {
        // all modified heavily
        
        var angle: CGFloat = 0
        
        angle = (1 - ratio) * CGFloat(-Double.pi / 2)
        
        return angle
    }
    
    func makePerspectiveTransform() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -2000
        return transform
    }
    
    func getRotation(indexPath: IndexPath, ratio: CGFloat) -> CATransform3D {
        var transform = makePerspectiveTransform()
        let angle = getAngle(indexPath: indexPath, ratio: ratio)
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        return transform
    }
    
}

