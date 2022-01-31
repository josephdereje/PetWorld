//
//  userService.swift
//  PetWorld
//
//  Created by joseph on 2020/5/30.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserService {
    static var currentUserProfile : UserProfile?
    
    static func obseUserProfile(_ uid: String ,  completion: @escaping ((_ userProfile:UserProfile?)->())) {
        
    
    
    let userRef = Database.database().reference().child("users/profile/\(uid)")
        
 
    userRef.observe(.value, with: { snapshot in
        
    var userProfile: UserProfile?
    
    if let data = snapshot.value as? [String:Any],
    let username = data["username"] as? String,
    let photoURL = data["photoURL"] as? String,
        
    let url = URL(string:photoURL) {
    
   userProfile = UserProfile(uid: snapshot.key, username: username, photoURL: url)
        }
    completion(userProfile)
    })
    
    }
    

}
    

