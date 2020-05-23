//
//  ViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/19.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var registerbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
       
        
         
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginbutton.alpha = 0.0
        registerbutton.alpha = 0.0
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = Auth.auth().currentUser {
            
            self.performSegue(withIdentifier: "homescreen", sender: self)
        }
        
        UIView.animate(withDuration: 2.0, animations: {
            self.loginbutton.alpha = 1.0
            self.registerbutton.alpha = 1.0 
            
        }, completion: nil)
        
        
    }

 
    
   
    
}


