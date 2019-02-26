//
//  Idea.swift
//  MyIdeaPool
//
//  Created by Star on 2/25/19.
//  Copyright © 2019 TopStar. All rights reserved.
//

import UIKit

class Idea: NSObject {
    var id : String?
    var content : String?
    var impact : Int?
    var ease : Int?
    var confidence : Int?
    var average_score : Double?
    var created_at : UInt64?
    
    required convenience init (dic : [String : Any]?) {
        
        self.init()
        
        id = dic?["id"] as? String
        content = dic?["content"] as? String
        impact = dic?["impact"] as? Int
        ease = dic?["ease"] as? Int
        confidence = dic?["confidence"] as? Int
        average_score = dic?["average_score"] as? Double
        created_at = dic?["created_at"] as? UInt64
    }
    
    func setWith (idea : Idea?) {
        self.id = idea?.id
        self.content = idea?.content
        self.impact = idea?.impact
        self.ease = idea?.ease
        self.confidence = idea?.confidence
        self.average_score = idea?.average_score
        self.created_at = idea?.created_at

    }

}
