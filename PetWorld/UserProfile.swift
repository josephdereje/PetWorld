//
//  userProfile.swift
//  PetWorld
//
//  Created by joseph on 2020/5/30.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import Foundation


class UserProfile {
    
    var uid : String
    var username : String
    var photoURL : URL

    init(uid: String , username: String , photoURL : URL ) {
       
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
        
        
    }
    
    
}
