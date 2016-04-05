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
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("GMSMapViewDelegate >> You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        self.putMarkerAt(coordinate.latitude, long: coordinate.longitude)
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        print("GMSMapViewDelegate >> map view idleAtCameraPosition", cameraPosition)
        
        let marker = GMSMarker()
        marker.position     = cameraPosition.target     // coordinate at center of the map
        marker.title        = "Test title"
        marker.snippet      = "Test snippet"
        marker.map = mapView
        
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        print("GMSMapViewDelegate >> tap info window \(marker)")
    }
    
    
    //TODO: ISSUE
    /**********************************
            ISSUE
     **********************************/
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let resources = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options:nil) as Array
        
        let optionalInfoWindow = resources.first as! CustomInfoWindow?
        
        if let infoWindow = optionalInfoWindow {
            infoWindow.time.text                = "5"
            infoWindow.distanceWithUnit.text    = "55 km"
            return infoWindow
        }
        return nil
    }
}

extension ViewController {
    
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