//
//  UserManager.swift
//  MyIdeaPool
//
//  Created by Star on 2/26/19.
//  Copyright © 2019 TopStar. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    
    static let shared = UserManager()
    let standard = UserDefaults.standard
    
    var refresh_token : String? {
        get {
            return standard.object(forKey: "refresh_token") as? String
        }
        set {
            standard.set(newValue, forKey: "refresh_token")
        }
    }
    
    var isLogined : Bool? {
        get {
            return standard.object(forKey: "isLogined") as? Bool
        }
        set {
            standard.set(newValue, forKey: "isLogined")
        }
    }

}
