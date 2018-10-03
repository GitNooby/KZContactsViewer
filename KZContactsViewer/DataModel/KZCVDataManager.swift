//
//  KZCVDataManager.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVDataManager: NSObject {
    private var contacts: Array<KZCVContactObject> = Array()
    private let serialAccessQueue: DispatchQueue = DispatchQueue(label: "com.kaizou.KZContactsViewer.KZCVDataManager")
    
    class func fetchMoreContacts() -> [KZCVContactObject]? {
        // TODO: If we're hitting an API endpoint, this function will need to be async
        return sharedDataManager.serialAccessQueue.sync { [weak sharedDataManager] in
            if sharedDataManager?.contacts.isEmpty == false {
                return sharedDataManager?.contacts
            }
            return sharedDataManager?.readContactsJSON()
        }
    }
    
    private override init() {
        super.init()
    }
    
    private static var sharedDataManager: KZCVDataManager = {
        return KZCVDataManager()
    }()
    
    private func readContactsJSON() -> [KZCVContactObject]? {
        if let path = Bundle.main.path(forResource: "contacts", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Array<Dictionary<String, String>> {
                    let jsonDecoder = JSONDecoder()
                    for aContact in jsonResult {
                        let encodedData = try JSONSerialization.data(withJSONObject: aContact, options: .prettyPrinted)
                        let decodedContact = try jsonDecoder.decode(KZCVContactObject.self, from: encodedData)
                        self.contacts.append(decodedContact)
                    }
                    return self.contacts
                }
            } catch {
                print("There was a problem parsing the contacts json (TODO: Handle errors gracefully)")
                return nil
            }
        }
        
        return nil
    }
}
