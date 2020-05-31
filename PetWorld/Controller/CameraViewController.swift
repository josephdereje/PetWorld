//
//  CameraViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/29.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController {
    
    let  cameraController = CameraController()
    @IBOutlet weak var cameraPreview: UIView!
    
    @IBOutlet weak var cameraPressedbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.cameraPreview)
            }
        }
        
        func styleCaptureButton() {
            cameraPressedbutton.layer.borderColor = UIColor.black.cgColor
            cameraPressedbutton.layer.borderWidth = 2
            
            cameraPressedbutton.layer.cornerRadius = min(cameraPressedbutton.frame.width, cameraPressedbutton.frame.height) / 2
        }
        
        styleCaptureButton()
        configureCameraController()
    }

    @IBAction func caotureImage(_ sender: UIButton) {
        
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
    }
}
}
    @IBAction func closeCamerapreview(_ sender: UIButton) {
        dismiss(animated: true , completion: nil)
    }
}
