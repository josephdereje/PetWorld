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
import Alamofire
import SwiftyJSON
class ScanViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITabBarControllerDelegate {
    
    
   
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textlabel : UILabel!
    var spinner = UIActivityIndicatorView()
    let imagepicker = UIImagePickerController()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var classificationResults : [VNClassificationObservation] = []
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
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
           // activityIndicator("scanning image")
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
        
        guard let model = try?VNCoreMLModel(for: Dog_classify().model)  else {
        
            fatalError("model cannot be loaded")
  
    }
         let request = VNCoreMLRequest(model: model) { (request, error) in
           
            
            guard let classfication = request.results?.first as? VNClassificationObservation else {
                
                
                fatalError("could not classify breed" )
            }
            
            
            // print(classfication)
           
                if classfication.confidence >= 0.60 {
                    self.navigationItem.title = classfication.identifier.capitalized
                    print(classfication)
                    self.requestInfo(breedname: classfication.identifier)
                } else {
                    print("no confidence")
                }
                

            
        }
            let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
            
        } catch {
            print(error)
        }
    }
    
    //Mark :- perfom request https
    func requestInfo(breedname: String) {
    
    let parameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts",
        "exintro" : "",
        "explaintext" : "",
        "titles" :  breedname,
        "indexpageids" : "",
        "redirects" : "1",
    ]
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
          
            if response.result.isSuccess {
                
                print("your informaton about dog breed is herer")
                //print(response)
                
                let breednameJson : JSON = JSON(response.result.value!)
                
                let pageid =  breednameJson["query"]["pageids"][0].stringValue
                let breeddesription =  breednameJson["query"]["pages"][pageid]["extract"].stringValue
                self.textlabel.text  = breeddesription
                
            }      else {
                print("Error \(String(describing: response.result.error))")
                self.textlabel.text = "Connection Issues"
            }
        }
        
        
    }
}












    
//    @IBAction func camerapressed(_ sender: UIBarButtonItem) {
//
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
//        {
//            present(imagepicker, animated: true, completion: nil)
//


//             let classifiaction = request.results?.first as? VNClassificationObservation
//
//              self.navigationItem.title = classifiaction?.identifier.capitalized
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//           // self.requestInfo(flowerName: classifiaction!.identifier)
//                        guard let results = request.results as? [VNClassificationObservation],
//                            let topResult = results.first
//                            else {
//                                fatalError("unexpected result type from VNCoreMLRequest")
//                        }
//
//
//                        if topResult.identifier.contains("dog") {
//
//                         // self.activityIndicator("Scanning image")
//                            DispatchQueue.main.async {
//                                self.navigationItem.title = "Dog"
//                                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4235294118, green: 0.8039215686, blue: 0.9450980392, alpha: 1)
//                                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//                                self.navigationController?.navigationBar.isTranslucent = false
//                            }
//                        }
//                        else {
//                            DispatchQueue.main.async {
//                                self.navigationItem.title = "Not Dog!"
//                                self.navigationController?.navigationBar.barTintColor = UIColor.red
//                                self.navigationController?.navigationBar.isTranslucent = false
//                            }
//                        }
