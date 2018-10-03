//
//  ViewController.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stuff = KZCVDataManager.fetchMoreContacts()
        print("\(stuff)")
        
    }

}

