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
    var postimage : postprofile
    var CreateDate : Date
    
    init(id:String, author:UserProfile,text:String,timestamp:Double,postimage: postprofile) {
        self.id = id
        self.author = author
        self.text = text
        self.postimage = postimage
        self.CreateDate = Date(timeIntervalSince1970: timestamp / 1000)
    }
    
    static func parse(_ key:String, _ data:[String:Any]) -> Post? {
        
        if let author = data["author"] as? [String:Any],
            let uid = author["uid"] as? String,
            //let userpostid = data["postid"] as? String ,
            let username = author["username"] as? String,
            let photoURL = author["photoURL"] as? String,
            let PostphotoURL = data["PostphotoURL"] as? String ,
            let posturl = URL(string: PostphotoURL) ,
            let url = URL(string:photoURL),
            let text = data["text"] as? String,
            let timestamp = data["timestamp"] as? Double {
            let userpostimage =  postprofile(PostphotoURL: posturl)
            let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
            return Post(id: key, author: userProfile, text: text, timestamp:timestamp, postimage: userpostimage )
            
        }
        
        return nil
    }


}

