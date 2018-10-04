//
//  ViewController.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVViewController: UIViewController {
    
    // Collection view for displaying image thumbnails
    private var contactsImageCollectionView: KZCVImageThumbnailCollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = KZCVImageThumbnailCollectionView.cellSize
        flowLayout.minimumLineSpacing = 0
        let collectionView = KZCVImageThumbnailCollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // Table view for displaying contact details
    private var contactsDetailTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // Array of contacts to be displayed
    private var contacts: [KZCVContactObject]? = KZCVDataManager.fetchMoreContacts()
    
    private let collectionViewCellId = "contactCollectionViewCell"
    private let tableViewCellId = "contactTableViewCell"
    
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
        self.contactsImageCollectionView.register(KZCVImageThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: self.collectionViewCellId)
        
        // Setup table view
        self.contactsDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.contactsDetailTableView)
        self.contactsDetailTableView.delegate = self
        self.contactsDetailTableView.dataSource = self
        self.contactsDetailTableView.register(UINib(nibName: "KZCVContactTableViewCell", bundle: nil), forCellReuseIdentifier: self.tableViewCellId)
        self.contactsDetailTableView.isPagingEnabled = true
        self.contactsDetailTableView.separatorStyle = .none
    }
    
    // This function will determine the closest cell in collection view to the center
    private func indexPathOfCenteredCell
        () -> IndexPath {
        let itemIndex = Int(round(self.contactsImageCollectionView.contentOffset.x / KZCVImageThumbnailCollectionView.cellSize.width))
        let numberOfItems = self.contactsImageCollectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, itemIndex))
        return IndexPath(item: safeIndex, section: 0)
    }
    
    // This function will set the grey ring for a particular cell in collection view
    private func setFocusRingForItemAtIndexPath(_ indexPath:IndexPath) {
        for item in self.contactsImageCollectionView.visibleCells as!
            [KZCVImageThumbnailCollectionViewCell] {
            item.setGrayCircleVisible(false)
        }
        let item = self.contactsImageCollectionView.cellForItem(at: indexPath)
        if let centeredItem = item {
            if let centered = centeredItem as? KZCVImageThumbnailCollectionViewCell {
                centered.setGrayCircleVisible(true)
            }
        }
    }
    
    private func circleCenterImage() {
        let indexPath = self.indexPathOfCenteredCell()
        self.setFocusRingForItemAtIndexPath(indexPath)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellId, for: indexPath) as! KZCVContactTableViewCell
        
        if let contacts = self.contacts {
            let contact = contacts[indexPath.row]
            if let firstName = contact.first_name, let lastName = contact.last_name {
                cell.setFirstName(firstName, lastName: lastName)
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
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionViewCellId, for: indexPath) as! KZCVImageThumbnailCollectionViewCell

        if let contacts = self.contacts {
            let contact = contacts[indexPath.item]
            if let avatarFilename = contact.getAvatarFileNameWithNoFileExtension() {
                let image = UIImage(named: avatarFilename)
                item.setImageThumbnail(image)
            }
        }
        if indexPath.item == self.indexPathOfCenteredCell().item {
            DispatchQueue.main.async {
                item.setGrayCircleVisible(true)
            }
        }
        return item
    }
}

extension KZCVViewController: UITableViewDelegate, UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.contactsDetailTableView.frame.height
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Scroll table view to correct cell when collection view cell is tapped
        self.contactsDetailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // This will force collection view and table view to scroll in lock-step
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
        
        // Make sure the right image thumbnail is circled when scrolling
        self.circleCenterImage()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // We're taking advantage of table view's paging to enforce paging for collection view
        if scrollView == self.contactsImageCollectionView {
            self.circleCenterImage()
            self.contactsDetailTableView.scrollToRow(at: self.indexPathOfCenteredCell()
                , at: .top, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // We're taking advantage of table view's paging to enforce paging for collection view
        if scrollView == self.contactsImageCollectionView {
            self.circleCenterImage()
            self.contactsDetailTableView.scrollToRow(at: self.indexPathOfCenteredCell(), at: .top, animated: true)
        }
    }

}

extension KZCVViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.contactsImageCollectionView.headerFooterWidth, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.contactsImageCollectionView.headerFooterWidth, height: 0)
    }
}
