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

//検索機能

//extension UISearchBar {
//    func disableBlur() {
//      backgroundImage = UIImage()
//      isTranslucent = true
//    }
//
//    var textField: UITextField? {
//        if #available(iOS 13.0, *) {
//            return searchTextField
//        } else {
//            return value(forKey: "_searchField") as? UITextField
//        }
//    }
//}
//
//extension UITextField{
//    var rightButton: UIButton? {
//        return leftView as? UIButton
//    }
//}
//extension UIButton {
//  func becomeImageAlwaysTemplate() {
//  }
//}
//
//extension UIImageView {
//  func becomeImageAlwaysTemplate() {
//    image = image?.withRenderingMode(.alwaysTemplate)
//  }
//}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    
    @IBOutlet var mapView:MKMapView!
    var locationManager = CLLocationManager()
    @IBOutlet weak var inputText: UISearchBar!
    //    @IBOutlet weak var Map: MKMapView!
    
    let coordinates = [CLLocationCoordinate2D(latitude: 35.647442, longitude: 139.734305), CLLocationCoordinate2D(latitude: 35.647023, longitude: 139.738682), CLLocationCoordinate2D(latitude: 35.644599, longitude: 139.735356)]
    
    
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
        
        //        長押しの認識
        //        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        //        myLongPress.addTarget(self, action: #selector(ViewController.recognizeLongPress(sender:)))
        //        mapView.addGestureRecognizer(myLongPress)
        
        
        //        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:35.658517, longitude: 139.70133399999997), latitudinalMeters: 500, longitudinalMeters: 500)
        //        mapView.setRegion(region, animated: false)
        
        //        let latitudes = [35.6582, 35.6576, 35.332820]
        //        let longitudes = [139.7018, 139.7019, 139.447457]
        
        for i in 0 ..< coordinates.count{
            let pin = MKPlacemark(coordinate: coordinates[i])
            mapView.addAnnotation(pin)
        }
        
    }
    @IBAction func back(sender: UIStoryboardSegue){
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        coordinates.firstIndex(where: {$0.latitude == view.annotation!.coordinate.latitude && $0.longitude == view.annotation!.coordinate.longitude})
        pinInformation = coordinates.firstIndex(where: {$0.latitude == view.annotation!.coordinate.latitude && $0.longitude == view.annotation!.coordinate.longitude})
        performSegue(withIdentifier: "tapped", sender: self)
    }
    var pinInformation :Int?
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
    
    //    長押しでピンをドロップ
    
    //    @ objc func recognizeLongPress(sender: UILongPressGestureRecognizer){
    //        if sender.state != UIGestureRecognizer.State.began{
    //            return
    //        }
    //        let mylocation = sender.location(in:mapView)
    //        let myCoordinate: CLLocationCoordinate2D = mapView.convert(mylocation, toCoordinateFrom: mapView)
    //        let myPin: MKPointAnnotation = MKPointAnnotation()
    //
    //        myPin.coordinate = myCoordinate
    //        //        myPin.title = "[]"
    //        //        myPin.subtitle = "[]"
    //        mapView.addAnnotation(myPin)
    //
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        vc.artistLocation = pinInformation!
        switch pinInformation! {
        case 0:
            vc.artistName = "牛乳少年"
            vc.artistphoto = UIImage(named: "milkboy")
            vc.demo1 = "もなか"
            vc.demo2 = "コーンフレーク"
            vc.demo3 = "サイゼ"
        case 1:
            vc.artistName = "Yonetu Kenzi"
            vc.artistphoto = UIImage(named: "kenshi")
            vc.demo1 = "馬と鹿"
            vc.demo2 = "ピースサイン"
            vc.demo3 = "Lemon"
        case 2:
            vc.artistName = "愛みょん"
            vc.artistphoto = UIImage(named: "aimyonn")
            vc.demo1 = "マリーゴールド"
            vc.demo2 = "愛を伝えたいだとか"
            vc.demo3 = "君はロックを聴かない"
        default:
            vc.artistName = "NO NAME"
            vc.artistphoto = UIImage(named: "appIcon")
            vc.demo1 = "NO DEMO"
            vc.demo2 = "NO DEMO"
            vc.demo3 = "NO DEMO"
        }
    }
}


