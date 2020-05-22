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
import GoogleMaps
import GooglePlaces


class MypetViewController: UIViewController {
var placesClient: GMSPlacesClient!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var namelable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let locationManager = CLLocationManager()
        // For getting the user permission to use location service when the app is running
       // locationManager.requestWhenInUseAuthorization()
        // For getting the user permission to use l0ocation service always
       // locationManager.requestAlwaysAuthorization()
            placesClient = GMSPlacesClient.shared()
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
       //
      
    }
    
    @IBAction func getcurrentlocation(_ sender: UIButton) {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            self.namelable.text = "No current place"
            self.addresslabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.namelable.text = place.name
                    self.addresslabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
    

   
}
