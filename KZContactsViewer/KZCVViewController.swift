//
//  ViewController.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVViewController: UIViewController {
    
    private var itemIndexWhenDragInitiated: Int = 0
    
    private func indexOfCenteredCell() -> Int {
        let itemIndex = Int(round(self.contactsImageCollectionView.contentOffset.x / KZCVImageThumbnailCollectionView.cellSize.width))
        let numberOfItems = self.contactsImageCollectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, itemIndex))
        return safeIndex
    }
    
    
    private var contactsImageCollectionView: KZCVImageThumbnailCollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
//        flowLayout.itemSize = KZCVImageThumbnailCollectionView.cellSize
//        flowLayout.headerReferenceSize = CGSize(width: 200, height: 150)
//        flowLayout.footerReferenceSize = CGSize(width: 200, height: 150)
        let collectionView = KZCVImageThumbnailCollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var contactsDetailTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private var contacts: [KZCVContactObject]? = KZCVDataManager.fetchMoreContacts()
    
    override func viewWillLayoutSubviews() {
        // Layout collection view
        self.contactsImageCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.contactsImageCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.contactsImageCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.contactsImageCollectionView.heightAnchor.constraint(equalToConstant: KZCVImageThumbnailCollectionView.collectionViewHeight).isActive = true
        
        // Layout table view
        self.contactsDetailTableView.topAnchor.constraint(equalTo: self.contactsImageCollectionView.bottomAnchor).isActive = true
        self.contactsDetailTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.contactsDetailTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.contactsDetailTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup collection view
        self.contactsImageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.contactsImageCollectionView)
        self.contactsImageCollectionView.delegate = self
        self.contactsImageCollectionView.dataSource = self
        self.contactsImageCollectionView.register(KZCVImageThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: "contactCollectionViewCell")
        self.contactsImageCollectionView.layer.borderColor = UIColor.green.cgColor
        self.contactsImageCollectionView.layer.borderWidth = 2
        
        // Setup table view
        self.contactsDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.contactsDetailTableView)
        self.contactsDetailTableView.delegate = self
        self.contactsDetailTableView.dataSource = self
        self.contactsDetailTableView.register(UINib(nibName: "KZCVContactTableViewCell", bundle: nil), forCellReuseIdentifier: "contactTableViewCell")
        self.contactsDetailTableView.isPagingEnabled = true
        self.contactsDetailTableView.layer.borderColor = UIColor.blue.cgColor
        self.contactsDetailTableView.layer.borderWidth = 2
        
        
        
    }

}

extension KZCVViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contacts = self.contacts {
            return contacts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCell", for: indexPath) as! KZCVContactTableViewCell
        
        if let contacts = self.contacts {
            let contact = contacts[indexPath.row]
            if let firstName = contact.first_name {
                cell.firstNameLabel.text = firstName
            }
            if let lastName = contact.last_name {
                cell.lastNameLabel.text = lastName
            }
            if let title = contact.title {
                cell.titleLabel.text = title
            }
            if let introduction = contact.introduction {
                cell.introductionTextView.text = introduction
            }
        }
        
        return cell
    }
    
    
}

extension KZCVViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let contacts = self.contacts {
            return contacts.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCollectionViewCell", for: indexPath) as! KZCVImageThumbnailCollectionViewCell
        
        if let contacts = self.contacts {
            let contact = contacts[indexPath.item]
            if let avatarFilename = contact.getAvatarFileNameWithNoFileExtension() {
                let image = UIImage(named: avatarFilename)
                item.setImageThumbnail(image)
            }
        }
        item.layer.borderColor = UIColor.red.cgColor
        item.layer.borderWidth = 3
        
        return item
    }
    
    
}

extension KZCVViewController: UITableViewDelegate, UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.contactsDetailTableView.frame.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.contactsDetailTableView.contentSize.height != 0 && self.contactsImageCollectionView.contentSize.width != 0 {
        
            if scrollView == self.contactsImageCollectionView {
                let collectionViewScrollRatio = self.contactsImageCollectionView.contentOffset.x / KZCVImageThumbnailCollectionView.cellSize.width
                self.contactsDetailTableView.contentOffset = CGPoint(x: 0, y: collectionViewScrollRatio * self.contactsDetailTableView.frame.height)
            }
            else if scrollView == self.contactsDetailTableView {
                let tableViewScrollRatio = self.contactsDetailTableView.contentOffset.y / self.contactsDetailTableView.frame.height
                self.contactsImageCollectionView.contentOffset = CGPoint(x: tableViewScrollRatio * KZCVImageThumbnailCollectionView.cellSize.width, y: 0)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.itemIndexWhenDragInitiated = self.indexOfCenteredCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == self.contactsImageCollectionView {

            let safeIndex = self.indexOfCenteredCell()
            
            let indexPath = IndexPath(item: safeIndex, section: 0)
            self.contactsDetailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.contactsImageCollectionView {
            let safeIndex = self.indexOfCenteredCell()
            let indexPath = IndexPath(item: safeIndex, section: 0)
            self.contactsDetailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
    }

}


extension KZCVViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return KZCVImageThumbnailCollectionView.cellSize
    }

//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        let f = KZCVImageThumbnailCollectionView.minimumSpacing
//        return 0
//    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.contactsImageCollectionView.headerFooterWidth, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.contactsImageCollectionView.headerFooterWidth, height: 0)
    }
}
