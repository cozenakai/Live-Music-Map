//
//  ViewController.swift
//  Live Music Map
//
//  Created by Masaki Chonan on 2020/05/23.
//  Copyright © 2020 Masaki Chonan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate{
    
    
    @IBOutlet var mapView:MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:35.658517, longitude: 139.70133399999997), latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: false)
        
        var pin = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 35.6581, longitude: 139.7017))
        
        mapView.addAnnotation(pin)
        
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "tapped", sender: self)
    }
}

