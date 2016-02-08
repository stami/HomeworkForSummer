//
//  Buddy.swift
//  HomeworkForSummer
//
//  Created by Samuli Tamminen on 8.2.2016.
//  Copyright © 2016 Samuli Tamminen. All rights reserved.
//

import Foundation

struct Buddy {
  
    var name: String
    var account: String
    
    init() {
        name = ""
        account = ""
    }
    
    init(name: String, account: String) {
        self.name = name
        self.account = account
    }
  
}