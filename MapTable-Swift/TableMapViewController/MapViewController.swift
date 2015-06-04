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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"selectAnnotation:", name: "selectAnnotation", object: nil)

        self.map = MKMapView(frame: frame)
        self.map!.delegate = self
        
        self.view.addSubview(self.map!)
        

       adjustRegion(37.3175,aLongitude: -122.0419)
    }
    
    func adjustRegion(aLatitude:CLLocationDegrees, aLongitude: CLLocationDegrees){
        var latitude:CLLocationDegrees = aLatitude
        var longitude:CLLocationDegrees = aLongitude
        var latDelta:CLLocationDegrees = 1.0
        var longDelta:CLLocationDegrees = 1.0
        
        var aSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta,longitudeDelta: longDelta)
        var Center :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(Center, aSpan)
        
        self.map!.setRegion(region, animated: true)
    }
    
    func loadPointsWithArray(someVenues:[Venue]){
        map!.removeAnnotations(map!.annotations)
       
        
        for (var i=0; i<someVenues.count; i++) {
    
            var point:MapPointAnnotation = MapPointAnnotation()
            var v = someVenues[i] as Venue
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
    func selectAnnotation(notification :NSNotification)  {
        self.selectedVenue = notification.object as? Venue
        var point:MKPointAnnotation = venuePoints[self.selectedVenue!.ident]!
        map!.selectAnnotation(point, animated: true)
    }
    
    //select venue from mapview
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        let p = view.annotation as! MapPointAnnotation
        self.selectedVenue = p.venue
        println("\(p.venue)")
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
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
            pinView!.pinColor = .Purple
        
            
            if self.rightButton == nil {
                self.rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as? UIButton
            }
           // let point:MapPointAnnotation = pinView!.annotation as! MapPointAnnotation
           // println("point.venue.name = \(point.venue?.name)")
          //  self.rightButton!.venue = point.venue
            self.rightButton!.titleForState(UIControlState.Normal)
            
          self.rightButton!.addTarget(self, action: "rightButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            pinView!.rightCalloutAccessoryView = self.rightButton! as UIView
   
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    


    func rightButtonTapped(sender: UIButton!){
        if let venue:Venue = selectedVenue{
            
            println("venue name:\(venue.name)")
            
            NSNotificationCenter.defaultCenter().postNotificationName("navigateToDetail", object: venue)
        } else {
            println("no venue")
        }
    }
    
    
}
