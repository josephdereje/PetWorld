//
//  SettingTableViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/6/6.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import Firebase

class SettingTableViewController: UITableViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()


}

    @IBAction func logout(_ sender: Any) {
      do {
        try? Auth.auth().signOut()
      
        self.dismiss(animated: false, completion: nil)
        
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
        }
}
}
