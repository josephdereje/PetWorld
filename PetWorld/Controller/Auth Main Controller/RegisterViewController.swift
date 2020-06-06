//
//  RegisterViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/21.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate{
    
    var ref: DatabaseReference!
    
   // ref = Database.database().reference()
   
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var taptochangeprofilebutton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
  
    var imagepicker : UIImagePickerController!
    
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
         imagepicker = UIImagePickerController()
        
        imagepicker.delegate = self
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        imagetap()

    
    }
    @IBAction func closebutton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // image picker for our profile picture
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePic.image = pickedimage
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagetap() {
        let imagetap = UITapGestureRecognizer(target: self, action: #selector(openimagepicker))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(imagetap)
        //profilePic.layer.cornerRadius = profilePic.bounds.height/2
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        profilePic.layer.borderWidth = 1
        profilePic.clipsToBounds = true
        taptochangeprofilebutton.addTarget(self, action: #selector(openimagepicker), for: .touchDown)
        
    }
    @objc func openimagepicker()  {
        self.present(imagepicker,animated: true, completion: nil)
    }
    
    
  // Register New User
    @IBAction func RegisterUser(_ sender: UIButton) {
        
        spinner.startAnimating()
        
        if let email = emailTextfield.text ,
            let password = passwordTextfield.text,
            let username = userNameTextfield.text ,
            let image = profilePic.image
        {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                DispatchQueue.main.async {
                    
                
                if error == nil && user != nil {
                    
                    print ("username created")
                    //Auth.auth().currentUser?.uid
                    
                    //self.errorMessages.text = "SucessFully Registered"
                    self.uploadProfileImage(image) { url in
                        
                        if url != nil {
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = username
                            changeRequest?.photoURL = url
                            
                            changeRequest?.commitChanges { error in
                                if error == nil {
                                    print("User display name changed!")
                                    
                                    self.saveProfile(username: username, profileImageURL: url!) { success in
                                        if success {
                                            //self.navigationController?.popToRootViewController(animated: true)
                                            //self.navigationController?.popViewController(animated: true)
                                       self.dismiss(animated: false, completion: nil)
                                        } else {
                                            let alert = UIAlertController(title: "Register Fail", message: "UploadImage", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Okay", style:.default, handler: nil))
                                            self.present(alert,animated: true ,completion: nil)
                                        }
                                        
                                    }
                                    
                                } else {
                                    let error = String(error!.localizedDescription)
                                    let alert = UIAlertController(title: "Register Fail", message: error, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style:.default, handler: nil))
                                    self.present(alert,animated: true ,completion: nil)
                                    self.spinner.stopAnimating()
                                    
                                  //  print("Error: \(error!.localizedDescription)")
                                }
                            }
                        } else {
                            self.spinner.stopAnimating()
                            let error = String(error!.localizedDescription)
                            let alert = UIAlertController(title: "Register Fail", message: error, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style:.default, handler: nil))
                            self.present(alert,animated: true ,completion: nil)
                            
                              print("no image")
                            // Error unable to upload profile image
                        }
                        
                    }
                    
                } else {
                    
                    self.spinner.stopAnimating()
                    let error = String(error!.localizedDescription)
                    let alert = UIAlertController(title: "Register Fail", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style:.default, handler: nil))
                    self.present(alert,animated: true ,completion: nil)
                    self.spinner.stopAnimating()
                   // print("Error: \(error!.localizedDescription)")
                }
                   // self.dismiss(animated: true, completion: nil)
                }
                }
    
                
            }
        }
    
    
   
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75)  else { return }
        
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
                storageRef.downloadURL { url ,error in
                    completion(url)
                }
            }else {
                    completion(nil)
                }
                // success!
         
            
        }
    }
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username": username,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
}
