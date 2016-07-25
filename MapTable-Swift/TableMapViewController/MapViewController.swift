//
//  MapViewController.swift
//  Map-swift
//
//  Created by Gazolla on 25/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    var venuePoints = [String:MapPointAnnotation]()
    var selectedVenue:Venue?
    var venues: [Venue]?
    
    lazy var map:MKMapView = {
        let m = MKMapView(frame: self.view.bounds)
        m.delegate = self
        return m
    }()
    
    lazy var rightButton: UIButton = { [unowned self] in
        let r = UIButton(type: UIButtonType.DetailDisclosure)
        r.titleForState(UIControlState.Normal)
        r.addTarget(self, action: #selector(MapViewController.rightButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return r
    }()
    
    var region:Position? {
        didSet {
            adjustRegion(region!.lat!,aLongitude: region!.lng!)
        }
    }
    
    convenience init(frame:CGRect){
        self.init(nibName: nil, bundle: nil)
        self.view.frame = frame
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MapViewController.selectAnnotation(_:)), name: "selectAnnotation", object: nil)
        
        self.view.addSubview(self.map)
        
        initialRegion()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.map.delegate = nil
    }
    
    func initialRegion(){
        adjustRegion(37.3175,aLongitude: -122.0419)
    }
    
    func adjustRegion(aLatitude:CLLocationDegrees, aLongitude: CLLocationDegrees, latDelta:CLLocationDegrees = 1.0, longDelta:CLLocationDegrees = 1.0){
        let latitude:CLLocationDegrees = aLatitude
        let longitude:CLLocationDegrees = aLongitude
        
        let aSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta,longitudeDelta: longDelta)
        let Center :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(Center, aSpan)
        
        self.map.setRegion(region, animated: true)
    }
    
    func loadPointsWithArray(someVenues:[Venue]){
        map.removeAnnotations(map.annotations)
        
        for i in 0..<someVenues.count {
            let point:MapPointAnnotation = MapPointAnnotation()
            let v = someVenues[i] as Venue
            point.venue = v
            let latitude = v.lat
            let longitude = v.lng
            point.coordinate = CLLocationCoordinate2DMake(latitude,longitude);
            point.title =  v.name
            point.subtitle = v.category
            venuePoints[v.ident] = point
            
            map.addAnnotation(point)
        }
    }
    
    // select venue from tableview
    func selectAnnotation(notification :NSNotification)  {
        self.selectedVenue = notification.object as? Venue
       
        if let venue = self.selectedVenue {
            adjustRegion(venue.lat, aLongitude: venue.lng, latDelta:0.01, longDelta:0.01)
            let point:MKPointAnnotation = venuePoints[self.selectedVenue!.ident]!
            map.selectAnnotation(point, animated: true)
        }
    }
    
    //select venue from mapview
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let p = view.annotation as! MapPointAnnotation
        self.selectedVenue = p.venue
        print("\(p.venue)")
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            if #available(iOS 9.0, *) {
                pinView!.pinTintColor = .purpleColor()
            } else {
                pinView!.pinColor = .Purple
            }
            pinView!.rightCalloutAccessoryView = self.rightButton as UIView
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func rightButtonTapped(sender: UIButton!){
        if let venue:Venue = selectedVenue {
            print("venue name:\(venue.name)")
            NSNotificationCenter.defaultCenter().postNotificationName("navigateToDetail", object: venue)
        } else {
            print("no venue")
        }
    }
    
}
