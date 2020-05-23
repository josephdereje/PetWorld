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

    @IBOutlet weak var currenuserimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      let user = Auth.auth().currentUser
      let Emailuser = user?.email
      
        navigationItem.title = Emailuser

        // Do any additional setup after loading the view.
    }
    func getuserimage(){
        
        //let userid = Auth.auth().currentUser?.uid
        
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
