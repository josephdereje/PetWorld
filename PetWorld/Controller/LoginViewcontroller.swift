//
//  LoginViewcontroller.swift
//  PetWorld
//
//  Created by joseph on 2020/5/20.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import Firebase

class LoginViewcontroller: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeloginview(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func loginPressedbutton(_ sender: UIButton) {
        
            spinner.startAnimating()
            if let email = self.emailTextfield.text , let password = self.passwordTextfield.text  {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
              
                DispatchQueue.main.async {
                    
                                    if error == nil {
                     self.dismiss(animated: false, completion: nil)
                                        
                                        
                }
                else {
                     self.spinner.stopAnimating()
                    print("error login : \(error!.localizedDescription)")
                
                   }
            }
            
        }
        }
}
}


