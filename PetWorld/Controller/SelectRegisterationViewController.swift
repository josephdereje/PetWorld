//
//  SelectRegisterationViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/22.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit

class SelectRegisterationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.hidesBackButton = true

   
    }
    

    @IBAction func closebutton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
