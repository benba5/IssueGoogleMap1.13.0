//
//  ViewController.swift
//  TestGoogleMapAPI
//
//  Created by appsynth on 12/4/15.
//  Copyright © 2015 appsynth. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps


class ViewController: UIViewController  {
    
    private let zoomLevel: Float = 15
    
    var mapView: GMSMapView!
    
    var fromMarker: GMSMarker?
    
    var myContext = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationService()
        
        initializeMapViewAtFixedLatitude(0, longitude: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // To prevent automatically unseleting the marker
        mapView.addObserver(self, forKeyPath: "selectedMarker", options: NSKeyValueObservingOptions.New.union(NSKeyValueObservingOptions.Old), context: nil)
        
        self.putMarkerAt(13.762817, long: 100.582584)
        self.putMarkerAt(13.7628919998214, long: 100.570806339383)
        self.putMarkerAt(13.7685878723028, long: 100.570005364716)
        self.putMarkerAt(13.7686191339266, long: 100.574107132852)
        self.putMarkerAt(13.7684944130482, long: 100.581125468016)
        self.putMarkerAt(13.7740970176775, long: 100.57875405997)
        self.putMarkerAt(13.7740970176775, long: 100.571447387338)
        self.putMarkerAt(13.7626116151172, long: 100.579042397439)
        self.putMarkerAt(13.7594990292437, long: 100.572857223451)
        self.putMarkerAt(13.7655997627992, long: 100.567826069891)
        self.putMarkerAt(13.7688366626101, long: 100.585355646908)
        self.putMarkerAt(13.7669850571967, long: 100.576880201697)
        self.putMarkerAt(13.7663389782731, long: 100.573661550879)
        self.putMarkerAt(13.7657345802449, long: 100.575657114387)
        self.putMarkerAt(13.7698819697782, long: 100.577330812812)
        self.putMarkerAt(13.7702779478462, long: 100.57488463819)
        self.putMarkerAt(13.7687357136953, long: 100.576515421271)
        self.putMarkerAt(13.7682772096887, long: 100.57801745832)
        self.putMarkerAt(13.7712157879637, long: 100.575914606452)
        self.putMarkerAt(13.7704446752532, long: 100.57630084455)
        
        self.mapView.animateToLocation(CLLocationCoordinate2D(latitude: 13.769, longitude: 100.576))
    }
    
    func configureLocationService() {
        let status = CLLocationManager.authorizationStatus()
        
        // User has never been asked to decide on location authorization
        if (status == CLAuthorizationStatus.NotDetermined) {
            let locManager = CLLocationManager();
            locManager.requestWhenInUseAuthorization()
        }
    }
    
    func initializeMapViewAtFixedLatitude(lat: CLLocationDegrees, longitude long: CLLocationDegrees) {
        
        let camera          = GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: zoomLevel)

        self.mapView                    = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.mapView.myLocationEnabled  = true
        self.mapView.mapType            = kGMSTypeNormal
        self.mapView.accessibilityElementsHidden = false

        self.mapView.settings.compassButton     = true
        self.mapView.settings.myLocationButton  = true
        
        self.mapView.delegate           = self
        
        // Listen to the myLocation property of GMSMapView.
       
        self.mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: &myContext)
        
        self.view                       = self.mapView
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        /*
        if keyPath == "myLocation" {
            if context == &myContext {
                if let newValue = change?[NSKeyValueChangeNewKey] {
                    
                    print("myLocation property has been changed to : \(newValue)")
                    
                    if let newLocation = newValue as? CLLocation {
                        self.mapView.camera = GMSCameraPosition.cameraWithTarget(newLocation.coordinate, zoom: self.mapView.camera.zoom)
                        self.mapView.removeObserver(self, forKeyPath: "myLocation", context:&myContext)
                    }
                }
            }
        }
        */
        if keyPath == "selectedMarker" {
            keepSelectMarkerIfNoNewSelected(change)
        }
    }
    
    func putMarkerAt(lat: CLLocationDegrees, long: CLLocationDegrees) {
        self.fromMarker     = self.creatMarkerAt(lat, long: long, filename: "icon_from")
        if let marker = self.fromMarker {
            marker.appearAnimation  = kGMSMarkerAnimationPop
            marker.map              = self.mapView
            //marker.title            = "From here"
            //marker.snippet          = "LINE man will pickup the stuff here"
        }
    }
    
    func creatMarkerAt(lat: CLLocationDegrees, long: CLLocationDegrees, filename name: String) -> GMSMarker {
        let marker      = GMSMarker()
        
        if let image = UIImage(named: name) {
            let icon = self.scaleImage(image, toSize: self.iconSize())
            marker.icon = icon
        }
        marker.position     = CLLocationCoordinate2DMake(lat, long)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        return marker
    }
}

extension ViewController: GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView, didCloseInfoWindowOfMarker marker: GMSMarker) {
        print("GMSMapViewDelegate >> Did close info window")
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        mapView.animateToLocation(marker.position)
        mapView.selectedMarker  = marker
        return true
    }
    
//    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
//        print("GMSMapViewDelegate >> You tapped at \(coordinate.latitude), \(coordinate.longitude)")
//        self.putMarkerAt(coordinate.latitude, long: coordinate.longitude)
//    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        print("GMSMapViewDelegate >> map view idleAtCameraPosition", cameraPosition)
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        print("GMSMapViewDelegate >> tap info window \(marker)")
    }
    
    
    //TODO: ISSUE
    /**********************************
            ISSUE
     **********************************/
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let resources           = NSBundle.mainBundle().loadNibNamed("SelectionPopup", owner: self, options:nil) as Array
        let optionalInfoWindow  = resources.first as! SelectionPopup
        return optionalInfoWindow
        
    }
}

extension ViewController {
    
    private func keepSelectMarkerIfNoNewSelected (change: [String: AnyObject]?) {
        print("----- keep select marker if no new selected ----")
        guard let change = change else {
            return
        }
        print("New \(change[NSKeyValueChangeNewKey])")
        print("Old \(change[NSKeyValueChangeOldKey])")
        if let old = change[NSKeyValueChangeOldKey] where change[NSKeyValueChangeNewKey] is NSNull {
            if let oldMarker = old as? GMSMarker {
                print("!!! KEEP SELECT OLD !!!")
                mapView.selectedMarker  = oldMarker
            }
        }
    }

    func iconSize() -> CGSize {
        return CGSize(width: self.view.bounds.width / 10, height: self.view.bounds.width / 10)
    }
    
    func scaleImage(image: UIImage, toSize size: CGSize) -> UIImage {
        
        // avoid redundant drawing
        if (CGSizeEqualToSize(image.size, size)){
            return image;
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        image.drawInRect(CGRectMake(0.0, 0.0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}


extension GMSAddress {
    func printAddressDetails (){
        print("-----------------------")
        print("coor", self.coordinate)
        
        if let thoroughfare = self.thoroughfare {
            print("thoroughfare", thoroughfare)
        }
        if let locality = self.locality {
            print("locality", locality)
        }
        if let subLocality = self.subLocality {
            print("sub locality", subLocality)
        }
        if let administrativeArea = self.administrativeArea {
            print("administrativeArea", administrativeArea)
        }
        if let code = self.postalCode {
            print("postalCode", code)
        }
        if let country = self.country {
            print("country", country)
        }
        if let lines = self.lines {
            print("lines", lines)
        }
    }
}