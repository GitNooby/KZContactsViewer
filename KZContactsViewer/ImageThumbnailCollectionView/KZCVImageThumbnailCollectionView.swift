//
//  KZCVImageThumbnailCollectionView.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVImageThumbnailCollectionView: UICollectionView {
    
    // TODO: this subclass seems mostly unnecessary, but putting static constants in the class they belong to make sense and computed values
    
    static let collectionViewHeight: CGFloat = 100.0
    static var cellSize: CGSize {
        get {
            return CGSize(width: collectionViewHeight, height: collectionViewHeight)
        }
    }
    var headerFooterWidth: CGFloat {
        get {
            return (self.frame.width - KZCVImageThumbnailCollectionView.cellSize.width) / 2
        }
    }
    
}
