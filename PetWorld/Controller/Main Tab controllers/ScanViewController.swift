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
    var spinner = UIActivityIndicatorView()
    let imagepicker = UIImagePickerController()
    var strLabel = UILabel()
     let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var classificationResults : [VNClassificationObservation] = []
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
            guard let convertimage = CIImage(image: userimage) else {
                fatalError("can not load the core ml image model")
                
            }
            
            imageView.image = userimage
            activityIndicator("scanning image")
            imageView.contentMode = .scaleAspectFit
            imagepicker.dismiss(animated: true, completion: nil)
            detectimage(image: convertimage)
            
        }
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
//            let spinner = UIActivityIndicatorView()
//            let midX  = self.view.frame.height/2
//            let midY = self.view.frame.width/2
            //let imagePicker = UIImagePickerController()
          
            imagepicker.delegate = self
            imagepicker.sourceType = UIImagePickerController.SourceType.camera
            imagepicker.allowsEditing = true
            
            present(self.imagepicker, animated: true, completion: nil)
        
           
            
             //activityIndicator("scanning image ")
//             spinner.frame = CGRect(x: midX, y: midY, width: 30, height: 30)
//            spinner.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//             spinner.startAnimating()
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    // open gallery image  function
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
    // adding spinner to the camera
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        spinner.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        spinner = UIActivityIndicatorView(style: .white)
        spinner.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        spinner.startAnimating()
        
        effectView.contentView.addSubview(spinner)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    // MARK:- Detect image for core ml
    
    func detectimage(image: CIImage) {
        
        guard let model = try?VNCoreMLModel(for: Inceptionv3().model)  else {
        
            fatalError("model cannot be loaded")
  
    }
         let request = VNCoreMLRequest(model: model) { (request, error) in
           
             let classifiaction = request.results?.first as? VNClassificationObservation
    
              self.navigationItem.title = classifiaction?.identifier.capitalized
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
           // self.requestInfo(flowerName: classifiaction!.identifier)
                        guard let results = request.results as? [VNClassificationObservation],
                            let topResult = results.first
                            else {
                                fatalError("unexpected result type from VNCoreMLRequest")
                        }
            
            
                        if topResult.identifier.contains("dog") {
                            
                         // self.activityIndicator("Scanning image")
                            DispatchQueue.main.async {
                                self.navigationItem.title = "Dog"
                                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4235294118, green: 0.8039215686, blue: 0.9450980392, alpha: 1)
                                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                                self.navigationController?.navigationBar.isTranslucent = false
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.navigationItem.title = "Not Dog!"
                                self.navigationController?.navigationBar.barTintColor = UIColor.red
                                self.navigationController?.navigationBar.isTranslucent = false
                            }
                        }
            
        }
            let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
            
        } catch {
            print(error)
        }
    }
        
}

    
//    @IBAction func camerapressed(_ sender: UIBarButtonItem) {
//
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
//        {
//            present(imagepicker, animated: true, completion: nil)
//



