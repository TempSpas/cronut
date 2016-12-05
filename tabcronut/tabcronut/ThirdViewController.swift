//
//  ThirdViewController.swift
//  tabcronut
//
//  Created by Jinxin Liu on 10/24/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// This file contains the map view 

import UIKit
import MapKit

class ThirdViewController: UIViewController {

    // MARK: properties
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsUserLocation = true
        
        mapView.delegate = self
        let loc1 = Location(title: "Cosco",locationName: "Supermarket", discipline: "Supermarket", coordinate: CLLocationCoordinate2D(latitude: 37.770080, longitude: -122.410934))
        let loc2 = Location(title: "Best Buy",locationName: "Supermarket", discipline: "Supermarket", coordinate: CLLocationCoordinate2D(latitude: 37.768520, longitude: -122.412650))
        let loc3 = Location(title: "Whole Foods",locationName: "Supermarket", discipline: "Supermarket", coordinate: CLLocationCoordinate2D(latitude: 37.764107, longitude: -122.402608))
        let loc4 = Location(title: "Whole Foods",locationName: "Supermarket", discipline: "Supermarket", coordinate: CLLocationCoordinate2D(latitude: 37.768382, longitude: -122.426641))
        let loc5 = Location(title: "Whole Foods",locationName: "Supermarket", discipline: "Supermarket", coordinate: CLLocationCoordinate2D(latitude: 37.781136, longitude: -122.399518))
        mapView.addAnnotation(loc1)
        mapView.addAnnotation(loc2)
        mapView.addAnnotation(loc3)
        mapView.addAnnotation(loc4)
        mapView.addAnnotation(loc5)
    }
    
    @IBAction func currentLoc(_ sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
