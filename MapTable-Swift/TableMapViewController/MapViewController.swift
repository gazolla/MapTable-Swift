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
    
    var venuePoints:[Int: MapPointAnnotation] = [Int:MapPointAnnotation]()
    var map:MKMapView?
    var venues: [Venue]?
    var rightButton: UIButton?
    var selectedVenue:Venue?
    

    convenience init(frame:CGRect){
        self.init(nibName: nil, bundle: nil)
        self.view.frame = frame
        
        NotificationCenter.default().addObserver(self, selector:#selector(MapViewController.selectAnnotation(_:)), name: "selectAnnotation", object: nil)

        self.map = MKMapView(frame: frame)
        self.map!.delegate = self
        
        self.view.addSubview(self.map!)
        

       adjustRegion(37.3175,aLongitude: -122.0419)
    }
    
    func adjustRegion(_ aLatitude:CLLocationDegrees, aLongitude: CLLocationDegrees){
        let latitude:CLLocationDegrees = aLatitude
        let longitude:CLLocationDegrees = aLongitude
        let latDelta:CLLocationDegrees = 1.0
        let longDelta:CLLocationDegrees = 1.0
        
        let aSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta,longitudeDelta: longDelta)
        let Center :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(Center, aSpan)
        
        self.map!.setRegion(region, animated: true)
    }
    
    func loadPointsWithArray(_ someVenues:[Venue]){
        map!.removeAnnotations(map!.annotations)
       
        
        for i in 0 ..< someVenues.count {
    
            let point:MapPointAnnotation = MapPointAnnotation()
            let v = someVenues[i] as Venue
            point.venue = v
            let latitude = (v.lat as NSString).doubleValue
            let longitude = (v.lng as NSString).doubleValue
            point.coordinate = CLLocationCoordinate2DMake(latitude,longitude);
            point.title =  v.name
            point.subtitle = v.categoryName
            venuePoints[v.ident] = point
    
            map!.addAnnotation(point)
        }
    }
    
    // select venue from tableview
    func selectAnnotation(_ notification :Notification)  {
        self.selectedVenue = notification.object as? Venue
        let point:MKPointAnnotation = venuePoints[self.selectedVenue!.ident]!
        map!.selectAnnotation(point, animated: true)
    }
    
    //select venue from mapview
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let p = view.annotation as! MapPointAnnotation
        self.selectedVenue = p.venue
        print("\(p.venue)")
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
            pinView!.pinColor = .purple
        
            
            if self.rightButton == nil {
                self.rightButton = UIButton(type: UIButtonType.detailDisclosure) 
            }
           // let point:MapPointAnnotation = pinView!.annotation as! MapPointAnnotation
           // println("point.venue.name = \(point.venue?.name)")
          //  self.rightButton!.venue = point.venue
            self.rightButton!.title(for: UIControlState())
            
          self.rightButton!.addTarget(self, action: #selector(MapViewController.rightButtonTapped(_:)), for: UIControlEvents.touchUpInside)
            pinView!.rightCalloutAccessoryView = self.rightButton! as UIView
   
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    


    func rightButtonTapped(_ sender: UIButton!){
        if let venue:Venue = selectedVenue{
            
            print("venue name:\(venue.name)")
            
            NotificationCenter.default().post(name: Notification.Name(rawValue: "navigateToDetail"), object: venue)
        } else {
            print("no venue")
        }
    }
    
    
}
