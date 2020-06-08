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
        
        let latitudes = [35.6582, 35.6576, 35.332820]
        let longitudes = [139.7018, 139.7019, 139.447457]
        
        for i in 0..<latitudes.count{
            let pin = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudes[i], longitude: longitudes[i]))
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
        directionRequest.destination = MKMapItem (placemark: pins[1])
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


