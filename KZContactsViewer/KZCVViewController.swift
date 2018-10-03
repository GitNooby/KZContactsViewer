//
//  ViewController.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVViewController: UIViewController {
    @IBOutlet weak var contactsImageCollectionView: UICollectionView!
    @IBOutlet weak var contactsDetailTableView: UITableView!
    
    private var contacts: [KZCVContactObject]? = KZCVDataManager.fetchMoreContacts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table view
        self.contactsDetailTableView.delegate = self
        self.contactsDetailTableView.dataSource = self
        self.contactsDetailTableView.register(UINib(nibName: "KZCVContactTableViewCell", bundle: nil), forCellReuseIdentifier: "contactTableViewCell")
        self.contactsDetailTableView.isPagingEnabled = true
        self.contactsDetailTableView.layer.borderColor = UIColor.red.cgColor
        self.contactsDetailTableView.layer.borderWidth = 2
        
        // Setup collection view
        self.contactsImageCollectionView.delegate = self
        self.contactsImageCollectionView.dataSource = self
        self.contactsImageCollectionView.register(KZCVImageThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: "contactCollectionViewCell")
        self.contactsImageCollectionView.layer.borderColor = UIColor.red.cgColor
        self.contactsImageCollectionView.layer.borderWidth = 2
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCollectionViewCell", for: indexPath) as! KZCVImageThumbnailCollectionViewCell
        
        if let contacts = self.contacts {
            let contact = contacts[indexPath.row]
            if let avatarFilename = contact.getAvatarFileNameWithNoFileExtension() {
                let image = UIImage(named: avatarFilename)
                cell.setImageThumbnail(image)
            }
        }
        
        
        return cell
    }
    
    
}

extension KZCVViewController: UITableViewDelegate, UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.contactsDetailTableView.frame.height
    }
}

