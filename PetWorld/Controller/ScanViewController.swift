//
//  ScanViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/20.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ScanViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITabBarControllerDelegate {
    
    
   
    @IBOutlet weak var imageView: UIImageView!
   
    let imagepicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagepicker.delegate = self
        imagepicker.dismiss(animated: true, completion: nil)
        
       // imagepicker.sourceType = .camera
//    imagepicker.sourceType = .photoLibrary
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userimage = info[.originalImage] as? UIImage
        {
            
            
            imageView.image = userimage
            imageView.contentMode = .scaleToFill
        }
            imagepicker.dismiss(animated: true, completion: nil)
            
        }
        
        
    
    @IBAction func addgallaery(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }

    }
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            //let imagePicker = UIImagePickerController()
            imagepicker.delegate = self
            imagepicker.sourceType = UIImagePickerController.SourceType.camera
            imagepicker.allowsEditing = false
            present(imagepicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            //let imagePicker = UIImagePickerController()
            imagepicker.delegate = self
            imagepicker.allowsEditing = true
            imagepicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            present(imagepicker, animated: true, completion: nil)
            
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func camerapressed(_ sender: UIBarButtonItem) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            present(imagepicker, animated: true, completion: nil)
        }
        
    }
    
}

