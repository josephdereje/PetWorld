//
//  MytabbarController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/20.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import  Vision

class MytabbarController: UITabBarController ,UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagepicker = UIImagePickerController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imagepicker.delegate = self
//        imagepicker.sourceType = .camera
//        self.delegate = self
    }
    
    // select  tab viecontroller
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//
//        if viewController is ScanViewController {
//            present(imagepicker, animated: true, completion: nil)
//           //imagepicker.dismiss(animated: true, completion: nil)
//        }
//
//
//
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let userimage = info[.originalImage] as? UIImage
//        {
//
////            let home = storyboard!.instantiateViewController(withIdentifier: "scanimage") as! ScanViewController
////             home.recivedimage = userimage
////
//            imagepicker.dismiss(animated: true, completion: nil)
//
//        }

    }




