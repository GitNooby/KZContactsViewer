//
//  KZCVContactObject.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVContactObject: NSObject, Codable {
    var first_name: String?
    var last_name: String?
    var avatar_filename: String?
    var title: String?
    var introduction: String?
}
