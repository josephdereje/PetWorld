//
//  AddPostViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/31.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class AddPostViewController: UIViewController , UITextViewDelegate{

    var post : Post!
    var homecell : HomePostTableViewCell?
    @IBOutlet weak var textcontet: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        textcontet.delegate = self
        
         ProfileImage.image = homecell?.userProfileimage.image
//        let user = Auth.auth().currentUser
//        UserService.obseUserProfile(user!.uid) { userProfile in
//            UserService.currentUserProfile =
//        }
        ProfileImage.layer.cornerRadius = ProfileImage.bounds.height/2
        ProfileImage.clipsToBounds = true
        //ProfileImage.image = pos
        
        
    }
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        textcontet.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            super.dismiss(animated: flag, completion: completion)
        })
    }
    
    @IBAction func cancelbutton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Post(_ sender: UIButton) {
        
        guard let userprofile = UserService.currentUserProfile else {
            
             print("no current user " )
            return
        }
        
        let postRef = Database.database().reference().child("posts").childByAutoId()
        
        let postObject = [
            "author": [
                "uid": userprofile.uid,
                "username": userprofile.username,
                "photoURL": userprofile.photoURL.absoluteString
            ],
            "text": textcontet.text!,
            "timestamp": [".sv":"timestamp"]
        ] as [String:Any]
        
        
        postRef.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
               
                
                print("there is not post " )

            }
        })
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textcontet.becomeFirstResponder()
    
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        postText.isHidden = !textView.text.isEmpty
    }
    
}
