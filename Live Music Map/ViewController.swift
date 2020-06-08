//
//  ViewController.swift
//  Live Music Map
//
//  Created by Masaki Chonan on 2020/05/23.
//  Copyright © 2020 Masaki Chonan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet var mapView:MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CLLocationManager.locationServicesEnabled()
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 5
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined{
            
            locationManager.requestWhenInUseAuthorization()
        }
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.follow, animated: true)
        self.mapView.delegate = self
        
        locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        
        self.view.addSubview(mapView)
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(ViewController.recognizeLongPress(sender:)))
        
        mapView.addGestureRecognizer(myLongPress)
        
        
        //        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:35.658517, longitude: 139.70133399999997), latitudinalMeters: 500, longitudinalMeters: 500)
        //        mapView.setRegion(region, animated: false)
        
        let latitudes = [35.6582, 35.6576, 35.332820]
        let longitudes = [139.7018, 139.7019, 139.447457]
        
        for i in 0..<latitudes.count{
            let pin = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudes[i], longitude: longitudes[i]))
            mapView.addAnnotation(pin)
        }
        
    }
    @IBAction func back(sender: UIStoryboardSegue){
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        performSegue(withIdentifier: "tapped", sender: self)
    }
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let myPinnIdentifier = "PinAnnotationIdentifier"
        
        var myPinView: MKPinAnnotationView!
        
        if myPinView == nil {
            myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinnIdentifier)
            myPinView.animatesDrop = true
            myPinView.canShowCallout = true
            return myPinView
        }
        myPinView.annotation = annotation
        return myPinView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: locations[0].coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: false)
    }
    
    @ objc func recognizeLongPress(sender: UILongPressGestureRecognizer){
        if sender.state != UIGestureRecognizer.State.began{
            return
        }
        let mylocation = sender.location(in:mapView)
        let myCoordinate: CLLocationCoordinate2D = mapView.convert(mylocation, toCoordinateFrom: mapView)
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        myPin.coordinate = myCoordinate
        //        myPin.title = "[]"
        //        myPin.subtitle = "[]"
        mapView.addAnnotation(myPin)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


