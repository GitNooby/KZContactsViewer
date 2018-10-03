//
//  KZCVImageThumbnailCollectionViewCell.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVImageThumbnailCollectionViewCell: UICollectionViewCell {
    
    private var imageThumbnailView: UIImageView = UIImageView()
    
    private let circleLayer: CAShapeLayer = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.imageThumbnailView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageThumbnailView)
    }
    
    private var _centered: Bool = false
    var centered: Bool {
        set {
            _centered = newValue
            if self.circleLayer.path == nil {
                self.circleLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
                self.circleLayer.lineWidth = 4
                self.circleLayer.fillColor = UIColor.clear.cgColor
                self.layer.addSublayer(circleLayer)
            }
            if _centered == true {
                self.circleLayer.strokeColor = UIColor.red.cgColor
            }
            else {
                self.circleLayer.strokeColor = UIColor.clear.cgColor
            }
        }
        get {
            return _centered
        }
    }
    
    func clearImageView() {
        self.imageThumbnailView.image = nil
    }
    
    func setImageThumbnail(_ image: UIImage?) {
        self.imageThumbnailView.image = image
        self.imageThumbnailView.frame = self.bounds
    }
    
}
