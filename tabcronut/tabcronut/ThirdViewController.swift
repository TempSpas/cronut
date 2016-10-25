//
//  ThirdViewController.swift
//  tabcronut
//
//  Created by Jinxin Liu on 10/24/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit
import MapKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true

        /*// set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 42.7302, longitude: -73.6788)
        
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(location: initialLocation)*/
    }
    
    
    @IBAction func currentLoc(_ sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            (userLocation.location?.coordinate)!, 2000, 2000)
        
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
