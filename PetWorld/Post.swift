//
//  post.swift
//  PetWorld
//
//  Created by joseph on 2020/5/30.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import Foundation
import Firebase

class Post{
    var id:String
    var author:UserProfile
    var text:String
    var CreateDate : Date
    
    init(id:String, author:UserProfile,text:String,timestamp:Double) {
        self.id = id
        self.author = author
        self.text = text
        self.CreateDate = Date(timeIntervalSince1970: timestamp / 1000)
    }
}
