//
//  MypetViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/21.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

//import GoogleMaps
//import GooglePlaces



class MypetViewController: UIViewController {
    
    @IBOutlet weak var deatilsetting: UIBarButtonItem!
    
    @IBOutlet weak var profileimage: UIImageView!
  //  let locationManager = CLLocationManager()
//var placesClient: GMSPlacesClient!
    @IBOutlet weak var usernamelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let user = UserService.currentUserProfile?.username
        
         usernamelabel.text = user
       //
       self.navigationController?.navigationBar.shadowImage = UIImage()
      
        profileimage.layer.cornerRadius = profileimage.bounds.height/2
        profileimage.clipsToBounds = true
        
        
        if let profileimageurl = UserService.currentUserProfile?.photoURL {
            
            profileimage.image = nil
            ImageAdd.getImage(withURL: profileimageurl) { (image, url) in
                let prouserme = UserService.currentUserProfile
                if prouserme?.photoURL.absoluteString == url.absoluteString {
                    
                    self.profileimage.image = image
                }
                else
                {
                    print("no image found ")
                }
            }
            
        } else {
            
            print("empty url")
        }
        
    }
    
    @IBAction func DeatilsSetting(_ sender: UIBarButtonItem) {
        
        
        let alertController = YBAlertController(title: "", message: "", style: .ActionSheet)
                alertController.touchingOutsideDismiss = true
        alertController.animated = false
        // button icon color
        alertController.buttonIconColor = UIColor.darkGray
        
   
        alertController.buttonFont = UIFont(name: "Avenir Next" , size: 18)
        alertController.buttonTextColor = UIColor.gray
        alertController.addButton(icon: UIImage(named: "setting"), title: "setting", action: {
             self.performSegue(withIdentifier: "settingviewtable", sender: self)
            
        })
       // alertController.addButton(icon: UIImage(named: <#T##String#>), title: <#T##String#>, action: <#T##() -> Void#>)
        alertController.addButton(icon: UIImage(named: "Photo Camera Icon"), title: "Setting", target: self, selector: Selector(("tap")))
        // add a button with closure
        alertController.addButton(icon: UIImage(named: "Photo Camera Icon"), title: "Tweet", action: {
            
            self.performSegue(withIdentifier: "settingview", sender: self)
            
            
            
            
            })
            // add a button (No image)
        alertController.addButton(title: "Open in Safari", target: self, selector: Selector(("tap")))
        alertController.cancelButtonTitle = "Cancel"
        alertController.cancelButtonFont = UIFont(name: "Avenir Next", size: 18)
     
        alertController.show()
    }
    @objc func tap() {
        
        
    }
}
//
//        let alertController = YBAlertController(title: "Menu", message: "Message", style: .ActionSheet)
//        // let alertController = YBAlertController(style: .ActionSheet)
//
//        // button lay out
//
//       alertController.buttonFont = UIFont(name: "Avenir Next", size: 20)
//
//
//        // add a button
//        alertController.addButton(icon: UIImage(named: "camera"), title: "Comment", target: self, selector: Selector(("tap")))
//        // add a button with closure
//        alertController.addButton(icon: UIImage(named: "tweet"), title: "Tweet", action: {
//            print("button tapped")
//        })
//        // add a button (No image)
//        alertController.addButton(title: "Open in Safari", target: self, selector: Selector(("tap")))
//
//
//
//        alertController.cancelButtonTitle = "Cancel"
//        alertController.cancelButtonFont = UIFont(name: "Avenir Next", size: 20)
//        alertController.cancelButtonTextColor = UIColor.blue
//        // if you use a cancel Button, set cancelButtonTitle
//        // alertController.cancelButtonTitle = "Cancel"
//
//
//        alertController.show()
//
//        func tap() {
//            print("tap")
//        }
//    }
    





//
//    @IBAction func getcurrentlocation(_ sender: UIButton) {
//
//        //locationManager.requestAlwaysAuthorization()
//        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
//
//            if let error = error {
//                print("Current Place error: \(error.localizedDescription)")
//                return
//            }
//
//            self.namelable.text = "No current place"
//            self.addresslabel.text = ""
//
//            if let placeLikelihoodList = placeLikelihoodList {
//                let place = placeLikelihoodList.likelihoods.first?.place
//                if let place = place {
//                    self.namelable.text = place.name
//                    self.addresslabel.text = place.formattedAddress?.components(separatedBy: ", ")
//                        .joined(separator: "\n")
//                }
//            }
//        })
//    }
    

   

// For getting the user permission to use location service when the app is running
//locationManager.requestWhenInUseAuthorization()
// For getting the user permission to use l0ocation service always
// locationManager.requestAlwaysAuthorization()
//placesClient = GMSPlacesClient.shared()
//        // Do any additional setup after loading the view.
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
//        self.view.addSubview(mapView)
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
