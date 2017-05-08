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
    var venues: [Venue]?
    var selectedVenue:Venue?
    
    lazy var map:MKMapView = {
        let m = MKMapView(frame: self.view.bounds)
        m.delegate = self
        return m
    }()

    lazy var rightButton: UIButton = {
        let rb = UIButton(type: UIButtonType.detailDisclosure)
        rb.title(for: UIControlState())
        rb.addTarget(self, action: #selector(MapViewController.rightButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        return rb
    }()
    
    var region:Position? {
        didSet {
            adjustRegion(region!.lat,aLongitude: region!.lng)
        }
    }


    convenience init(frame:CGRect){
        self.init(nibName: nil, bundle: nil)
        self.view.frame = frame
        
         NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.selectAnnotation(_:)), name: NSNotification.Name(rawValue: "selectAnnotation"), object: nil)
        
        self.view.addSubview(self.map)
 

        initialRegion()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        self.map.delegate = nil
    }

    
    func initialRegion(){
        adjustRegion(37.3175,aLongitude: -122.0419)
    }
    

    func adjustRegion(_ aLatitude:CLLocationDegrees, aLongitude: CLLocationDegrees, latDelta:CLLocationDegrees = 1.0, longDelta:CLLocationDegrees = 1.0){
        let latitude = aLatitude
        let longitude = aLongitude
        
        let aSpan = MKCoordinateSpan(latitudeDelta: latDelta,longitudeDelta: longDelta)
        let Center = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(Center, aSpan)
        
        self.map.setRegion(region, animated: true)
    }
    
    func loadPointsWithArray(_ someVenues:[Venue]){
        map.removeAnnotations(map.annotations)
        for i in 0 ..< someVenues.count {

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
    func selectAnnotation(_ notification :NSNotification)  {
        self.selectedVenue = notification.object as? Venue
        

        if let venue = self.selectedVenue {
            adjustRegion(venue.lat, aLongitude: venue.lng, latDelta:0.01, longDelta:0.01)
            let point:MKPointAnnotation = venuePoints[self.selectedVenue!.ident]!
            map.selectAnnotation(point, animated: true)
        }
    }
    
    func rightButtonTapped(_ sender: UIButton!){
        if let venue:Venue = selectedVenue{
            print("venue name:\(venue.name)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "navigateToDetail"), object: venue)
        } else {
            print("no venue")
        }
    }

    //select venue from mapview
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let p = view.annotation as! MapPointAnnotation
        self.selectedVenue = p.venue
        print("\(String(describing: p.venue))")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .purple
            pinView!.rightCalloutAccessoryView = self.rightButton as UIView
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

}
