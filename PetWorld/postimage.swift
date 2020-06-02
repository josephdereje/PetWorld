//
//  postimage.swift
//  PetWorld
//
//  Created by joseph on 2020/6/2.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import Foundation
import Firebase
class postimage {
    
       static var currentuserpost : postprofile?
  
    
    static func obseUserpost(_ postid: String ,  completion: @escaping ((_ userpost:postprofile?)->())) {
        
        let postimageRef = Database.database().reference().child("posts/")
        postimageRef.observe(.value, with: { (snapshot) in
            var userpost : postprofile?
            if let data = snapshot.value as? [String:Any],
                
                let postPhotoURL = data["PostphotoURL"] as? String ,
                
                let url = URL(string: postPhotoURL) {
                
                userpost = postprofile(PostphotoURL: url)
            }
    
         completion(userpost)
            })
            
        }
        
    }
    
    
