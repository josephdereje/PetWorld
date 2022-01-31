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

protocol NewPostVCDelegate {
    func didUploadPost(withID id:String)
}
class AddPostViewController: UIViewController , UITextViewDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var delegate:NewPostVCDelegate?
    var post : Post?
    var homecell : HomePostTableViewCell?
    var imagepost : postprofile?
   // var profileimage : UIImage?
    
    @IBOutlet weak var addpostImage: UIButton!
    // weak var post : Post?
    @IBOutlet weak var textcontet: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    var imagepicker : UIImagePickerController!
  
    @IBOutlet weak var postdone: UIButton!
    @IBOutlet weak var ProfileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        textcontet.delegate = self
        
        imagepicker = UIImagePickerController()
        
        imagepicker.delegate = self
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        
//        let user = Auth.auth().currentUser
//        UserService.obseUserProfile(user!.uid) { userProfile in
//            UserService.currentUserProfile =
//        }
        ProfileImage.layer.cornerRadius = ProfileImage.bounds.height/2
        ProfileImage.clipsToBounds = true
     
        
        if let profileimageurl = UserService.currentUserProfile?.photoURL {
            
             ProfileImage.image = nil
            ImageAdd.getImage(withURL: profileimageurl) { (image, url) in
              let prouserme = UserService.currentUserProfile
                if prouserme?.photoURL.absoluteString == url.absoluteString {
                    
                    self.ProfileImage.image = image
                }
                else
                {
                    print("no image found ")
                }
            }
            
        } else {
            
            print("empty url")
        }
        
        
        //ProfileImage.image = pos
     
        //self.ProfileImage.image = nil
        
        postdone.clipsToBounds = true
        imagetap()
      
       
    }
    
   
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        textcontet.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            super.dismiss(animated: flag, completion: completion)
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.postImage.image = pickedimage
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
 
    
   // set user image
//    func getProfileimage() {
//
//
//        ImageAdd.getImage(withURL: (post?.author.photoURL)!) { (image, url) in
//            guard let _post = self.post else { return }
//            if _post.author.photoURL.absoluteString == url.absoluteString {
//
//                self.profileimage = image
//            }
//            else
//            {
//                print("no image found ")
//            }
//
//        }
//}
    func imagetap() {
        
        let imagetap = UITapGestureRecognizer(target: self, action: #selector(openimagepicker))
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(imagetap)
        //profilePic.layer.cornerRadius = profilePic.bounds.height/2
        postImage.contentMode = .scaleAspectFit
         postImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        postImage.clipsToBounds = true
        addpostImage.addTarget(self, action: #selector(openimagepicker), for: .touchDown)
        
    }
    @objc func openimagepicker()  {
        self.present(imagepicker,animated: true, completion: nil)
    }
  
    
        
        
    
    
    
    @IBAction func cancelbutton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Post(_ sender: UIButton) {

        let postRef = Database.database().reference().child("posts").childByAutoId()
        if  let userprofile = UserService.currentUserProfile
//                    ,let userpost = postimage.currentuserpost
        {
         self.spinner.startAnimating()
            uploadpostImage() { url in
                
                guard let url = url else { return }
                let postObject = [
                    "author": [
                        "uid": userprofile.uid,
                        "username": userprofile.username,
                        "photoURL": userprofile.photoURL.absoluteString
                        
                    ],
                   // "PostphotoURL" : userpost.PostphotoURL.absoluteString,
                    "PostphotoURL" : url,
                    "text": self.textcontet.text!,
                    "timestamp": [".sv":"timestamp"]
                    ] as [String:Any]
                
               
                
                DispatchQueue.main.async{
                    postRef.setValue(postObject, withCompletionBlock: { error, ref in
                        if error == nil {
                            self.delegate?.didUploadPost(withID: ref.key!)
                            self.dismiss(animated: true, completion: nil)
                            self.spinner.stopAnimating()
                            
                        } else {
                            
                            
                            print("there is not post " )
                            
                        }
                    })
                    
                    
                }
            }
            
          
            
        } else {
            
            print("not imag")
        }
        
       
        // uploading post image
        
     
        
        
        
      
        
        
    }
    
    func uploadpostImage(completion: @escaping (_ url: String?)-> Void) {
       
        let storageRef = Storage.storage().reference().child("posts/\(NSUUID().uuidString)")
         let image = postImage.image!
        
        guard let imageData = image.jpegData(compressionQuality: 0.75)  else { return }
        
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
                storageRef.downloadURL { url ,error in
                    completion(url!.absoluteString)
                }
            }else {
                
                let e =  String(error!.localizedDescription)
                completion(e)
            }
            // success!
            
            
        }
    }

    
//    func savepostImage( postImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
//
//        let databaseRef = Database.database().reference().child("posts")
//
//        let userObject = [
//            "PostphotoURL": postImageURL.absoluteString
//            ] as [String:Any]
//
//
//        }
//

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textcontet.becomeFirstResponder()
        
        // Remove the nav shadow underline
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        postText.isHidden = !textcontet.text.isEmpty
    }
    
}
