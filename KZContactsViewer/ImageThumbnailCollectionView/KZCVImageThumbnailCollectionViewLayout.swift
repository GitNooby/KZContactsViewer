//
//  KZCVImageThumbnailCollectionViewLayout.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVImageThumbnailCollectionViewLayout: UICollectionViewLayout {

    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: KZCVImageThumbnailCollectionView.collectionViewHeight, height: KZCVImageThumbnailCollectionView.collectionViewHeight)
        }
    }
    
}
