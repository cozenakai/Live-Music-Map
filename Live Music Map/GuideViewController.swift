//
//  GuideViewController.swift
//  Live Music Map
//
//  Created by Masaki Chonan on 2020/05/27.
//  Copyright © 2020 Masaki Chonan. All rights reserved.
//

import UIKit
import MapKit

class GuideViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var mapView:MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()

        // Do any additional setup after loading the view.
        
        var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.658517, longitude: 139.70133399999997), latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: false)
        
        var pin = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 35.6581, longitude: 139.7017))
        
        mapView.addAnnotation(pin)
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

extension UIViewController {

    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
}
