//
//  RegisterViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/21.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

   
    @IBOutlet weak var errorMessages: UILabel!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
  // Register New User
    @IBAction func RegisterUser(_ sender: Any) {
        if let email = emailTextfield.text , let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
               
                if let e = error{
                    print (e)
 
                    return
                    
                } else {
                    self.performSegue(withIdentifier: "homeview", sender: self)
                }
                
            }
        }
    }
    
}
