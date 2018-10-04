//
//  KZCVImageThumbnailCollectionView.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVImageThumbnailCollectionView: UICollectionView {
    
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
//    static var minimumSpacing: CGFloat {
//        get {
//            return collectionViewHeight//* 0.3 / 2
//        }
//    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
