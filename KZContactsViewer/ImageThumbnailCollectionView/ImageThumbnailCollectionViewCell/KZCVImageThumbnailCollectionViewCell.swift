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
    
    override func layoutSubviews() {
        self.imageThumbnailView.translatesAutoresizingMaskIntoConstraints = false
        self.imageThumbnailView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: KZCVImageThumbnailCollectionView.cellSize.width * 0.2).isActive = true
        self.imageThumbnailView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: KZCVImageThumbnailCollectionView.cellSize.width * -0.2).isActive = true
        self.imageThumbnailView.topAnchor.constraint(equalTo: self.topAnchor, constant: KZCVImageThumbnailCollectionView.cellSize.width * 0.2).isActive = true
        self.imageThumbnailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: KZCVImageThumbnailCollectionView.cellSize.width * -0.2).isActive = true
    }
    
    func clearImageView() {
        self.imageThumbnailView.image = nil
    }
    
    func setImageThumbnail(_ image: UIImage?) {
        self.imageThumbnailView.image = image
    }
    
    private var _centered: Bool = false  // instance variable backing the public variable "centered"
    var centered: Bool {
        set {
            _centered = newValue
            if self.circleLayer.path == nil {
                self.circleLayer.path = UIBezierPath(ovalIn: self.imageThumbnailView.frame).cgPath
                self.circleLayer.lineWidth = 4
                self.circleLayer.fillColor = UIColor.clear.cgColor
                self.layer.addSublayer(circleLayer)
            }
            if _centered == true {
                self.circleLayer.strokeColor = UIColor.lightGray.cgColor
            }
            else {
                self.circleLayer.strokeColor = UIColor.clear.cgColor
            }
        }
        get {
            return _centered
        }
    }
    
}
