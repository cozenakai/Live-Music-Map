//
//  GuideViewController.swift
//  Live Music Map
//
//  Created by Masaki Chonan on 2020/05/27.
//  Copyright © 2020 Masaki Chonan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GuideViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var mapView:MKMapView!
    
    var locationManager = CLLocationManager()
    var pins = [MKPlacemark]()
    var DestinationLocation : Int?
     let coordinates = [CLLocationCoordinate2D(latitude: 35.647442, longitude: 139.734305), CLLocationCoordinate2D(latitude: 35.647023, longitude: 139.738682), CLLocationCoordinate2D(latitude: 35.644599, longitude: 139.735356)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CLLocationManager.locationServicesEnabled()
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 5
        
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.follow, animated: true)
        self.mapView.delegate = self
        
        locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        
        
        for i in 0..<coordinates.count{
            let pin = MKPlacemark(coordinate: coordinates[i])
            mapView.addAnnotation(pin)
            pins.append(pin)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: locations[0].coordinate))
        directionRequest.destination = MKMapItem (placemark: pins[DestinationLocation!])
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            print(directionResponse)
            
            let route = directionResponse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 8.0
        return renderer
    }
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
    
}


