//
//  TableMapViewController.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit
import MapKit

class TableMapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    var navHeight:CGFloat?
    var width:CGFloat?
    var halfHeight:CGFloat?
    var height:CGFloat?
    var firstPosition = true
    var tableController:VenuesTableView?
    var venues: Array<Venue> = [Venue]()
    var mapView:MapViewController?
    var tapFirstView:UIGestureRecognizer?
    var bigMap = false
    var detailVenue:VenueDetailViewController?

    
     convenience init(frame:CGRect){
        self.init(nibName: nil, bundle: nil)
        navHeight = 0.0
        width = frame.size.width
        halfHeight = (frame.size.height - navHeight!)/2
        height = frame.size.height
        
        title = "Map & Table"
        
        NotificationCenter.default().addObserver(self, selector: #selector(TableMapViewController.mapViewTapped), name: "mapViewTapped", object: nil)
        
        mapView = MapViewController(frame: CGRect(x: 0.0, y: navHeight!, width: width!, height: halfHeight!))
      
        tapFirstView = UITapGestureRecognizer(target: self, action: #selector(TableMapViewController.mapViewTapped))
        mapView!.view.addGestureRecognizer(tapFirstView!)
        self.view.addSubview(self.mapView!.view)
        
        tableController = VenuesTableView(frame: CGRect(x: 0.0, y: halfHeight!, width: width!, height: halfHeight!))
        view.addSubview(tableController!.view)
        
        NotificationCenter.default().addObserver(self, selector: #selector(TableMapViewController.navigateToDetail(_:)), name: "navigateToDetail", object: nil)
        
        
    }
    
    func mapViewTapped(){
        if (!bigMap){
            UIView.animate(withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 20.0,
                options: UIViewAnimationOptions.curveEaseIn ,
                animations: {
                    self.mapView!.view.frame = CGRect(x: 0.0, y: self.navHeight!, width: self.width!, height: self.height!)
                    self.mapView!.map!.frame = CGRect(x: 0.0, y: self.navHeight!, width: self.width!, height: self.height!)
                    self.tableController!.view.center = CGPoint(x: self.tableController!.view.center.x, y: self.tableController!.view.center.y+self.halfHeight!);
                },
                completion:{ (Bool)  in
                    let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(TableMapViewController.reverse))
                    self.navigationItem.leftBarButtonItem = leftBarButtonItem
                    self.bigMap = true
                })
        }
    }
    
    func reverse(){
        if bigMap {
            UIView.animate(withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 20.0,
                options: UIViewAnimationOptions.curveEaseIn ,
                animations: {
                    self.mapView!.view.frame = CGRect(x: 0.0, y: self.navHeight!, width: self.width!, height: self.halfHeight!)
                    self.mapView!.map!.frame = CGRect(x: 0.0, y: self.navHeight!, width: self.width!, height: self.halfHeight!)
                    self.tableController!.view.center = CGPoint(x: self.tableController!.view.center.x, y: self.tableController!.view.center.y-self.halfHeight!);
                },
                completion:{ (Bool)  in
                    self.navigationItem.leftBarButtonItem = nil
                    self.bigMap = false
                    
                    if let selectedAnnotations = self.mapView!.map!.selectedAnnotations as? [MapPointAnnotation]{
                        for annotation in selectedAnnotations {
                            self.mapView!.map!.deselectAnnotation(annotation, animated: true)
                        }
                    }
                })
        }
        
    }

    func setVenueCollection(_ array: [Venue]!) {
         if (array != nil) {
            venues = array!
            tableController!.loadVenues(array!)
            mapView!.loadPointsWithArray(array!)
        }
    }
    
    func navigateToDetail(_ notification:Notification){
        
        if self.detailVenue == nil {
            self.detailVenue = VenueDetailViewController()
        }
        if let venue:Venue = notification.object as? Venue {
            self.detailVenue?.lblName?.text = venue.name
            self.detailVenue?.lblAddress?.text = venue.address
            self.detailVenue?.lblCity?.text = venue.city
        } else {
            print("no venue at TableMapController")
        }
        self.navigationController?.pushViewController(self.detailVenue!, animated: true)
        
    }
    
    
    
}
