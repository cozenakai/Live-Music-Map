//
//  GuideViewController.swift
//  Live Music Map
//
//  Created by Masaki Chonan on 2020/05/27.
//  Copyright © 2020 Masaki Chonan. All rights reserved.
//

import UIKit
import MapKit


class GuideViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var mapView:MKMapView!
    var locationManager = CLLocationManager()
    var pin = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 35.6581, longitude: 139.7017))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        CLLocationManager.locationServicesEnabled()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined{
            
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.658517, longitude: 139.70133399999997), latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: false)
        
        var latitudes = [35.6582, 35.6576, 35.332820]
               var longitudes = [139.7018, 139.7019, 139.447457]
               
               for i in 0..<latitudes.count{
                   var pin = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudes[i], longitude: longitudes[i]))
                   mapView.addAnnotation(pin)
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
        directionRequest.destination = MKMapItem (placemark: pin)
        directionRequest.transportType = .automobile
    
        let directions = MKDirections(request: MKDirections.Request())
        directions.calculate{ (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    print("経路の設定に失敗しました")
                }
               return
            }
            
            let route = directionResponse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
        }
        self.mapView.delegate = self
        func mapView(_mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4.0
            return renderer
        }
    }
    

}


