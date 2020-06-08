//
//  DetailViewController.swift
//  Live Music Map
//
//  Created by Masaki Chonan on 2020/05/27.
//  Copyright © 2020 Masaki Chonan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet var mapView:MKMapView!
    @IBOutlet weak var button: UIButton!
    var locationManager = CLLocationManager()
    var pins = [MKPlacemark]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CLLocationManager.locationServicesEnabled()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.delegate = self
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //      新宿に固定
        //        var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:35.658517 , longitude:139.70133399999997 ), latitudinalMeters: 500, longitudinalMeters: 500)
        //        mapView.setRegion(region, animated: false)
        
        
        let latitudes = [35.6582, 35.6576, 35.332820]
        let longitudes = [139.7018, 139.7019, 139.447457]
        
        for i in 0..<latitudes.count{
            let pin = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudes[i], longitude: longitudes[i]))
            mapView.addAnnotation(pin)
            pins.append(pin)
        }
        
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3.0
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "tapped", sender: self)
    }
    //
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let region = MKCoordinateRegion(center: locations[0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    //               mapView.setRegion(region, animated: false)
    //    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


