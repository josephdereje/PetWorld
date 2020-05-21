//
//  HomeViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/21.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutbuttonpressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            
            //navigationController?.popToRootViewController(animated: true)
             self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
        }
    }
    

}
