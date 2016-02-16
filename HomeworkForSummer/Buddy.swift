//
//  Buddy.swift
//  HomeworkForSummer
//
//  Created by Samuli Tamminen on 8.2.2016.
//  Copyright © 2016 Samuli Tamminen. All rights reserved.
//

import Foundation



class Buddy : NSObject, NSCoding {
  
    // MARK: Properties
    
    var name: String
    var account: String
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("buddies")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let accountKey = "account"
    }

    
    // MARK: Initialization
    
    // failable initializer
    init?(name: String, account: String) {
        // Initialize stored properties.
        self.name = name
        self.account = account
        
        super.init()
        
        // Initialization should fail if there is no name or account
        if name.isEmpty || account.isEmpty {
            return nil
        }
    }


    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(account, forKey: PropertyKey.accountKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let account = aDecoder.decodeObjectForKey(PropertyKey.accountKey) as! String
        
        // Must call designated initializer.
        self.init(name: name, account: account)
    }

  
}


