//
//  User.swift
//  MyIdeaPool
//
//  Created by Star on 2/25/19.
//  Copyright © 2019 TopStar. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name : String?
    var email : String?
    var password : String?
    
    required convenience init (email : String? = nil, password : String? = nil, name : String? = nil) {
        
        self.init()
        
        self.name = name
        self.email = email
        self.password = password
    }
    
    
    

}
