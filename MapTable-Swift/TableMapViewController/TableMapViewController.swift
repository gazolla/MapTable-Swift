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

    var navHeight:CGFloat { return 0.0 }
    var width:CGFloat { return self.view.bounds.size.width }
    var halfHeight:CGFloat {return (self.height - self.navHeight)/2}
    var height:CGFloat { return self.view.bounds.size.height }
    
    var firstPosition = true
    var venues = [Venue]()
    var bigMap = false
    
    lazy var mapView:MapViewController = {
        let m =  MapViewController(frame: CGRect(x: 0.0, y: self.navHeight, width: self.width, height: self.halfHeight))
        m.view.addGestureRecognizer(self.tapFirstView)
        return m
    }()
    
    lazy var tapFirstView:UIGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(TableMapViewController.mapViewTapped))
    }()
    
    lazy var tableController:VenuesTableView = {
        return VenuesTableView(frame: CGRect(x: 0.0, y: self.halfHeight, width: self.width, height: self.halfHeight))
    }()

    lazy var detailVenue:VenueDetailViewController = {
        return VenueDetailViewController()
    }()

    
    convenience init(frame:CGRect){
        self.init(nibName: nil, bundle: nil)

        self.view.addSubview(self.mapView.view)
        self.view.addSubview(self.tableController.view)

        title = "Map & Table"
        
        NotificationCenter.default.addObserver(self, selector: #selector(TableMapViewController.mapViewTapped), name: NSNotification.Name(rawValue: "mapViewTapped"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(TableMapViewController.navigateToDetail(_:)), name: NSNotification.Name(rawValue: "navigateToDetail"), object: nil)

    }
    
    func mapViewTapped(){
        if (!bigMap){
            UIView.animate(withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 20.0,
                options: UIViewAnimationOptions.curveEaseIn ,
                animations: {
                    self.mapView.view.frame = CGRect(x: 0.0, y: self.navHeight, width: self.width, height: self.height)
                    self.mapView.map.frame = CGRect(x: 0.0, y: self.navHeight, width: self.width, height: self.height)
                    self.tableController.view.center = CGPoint(x: self.tableController.view.center.x, y: self.tableController.view.center.y+self.halfHeight);
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
                    self.mapView.view.frame = CGRect(x: 0.0, y: self.navHeight, width: self.width, height: self.halfHeight)
                    self.mapView.map.frame = CGRect(x: 0.0, y: self.navHeight, width: self.width, height: self.halfHeight)
                    self.tableController.view.center = CGPoint(x: self.tableController.view.center.x, y: self.tableController.view.center.y-self.halfHeight);
                },
                completion:{ (Bool)  in
                    self.navigationItem.leftBarButtonItem = nil
                    self.bigMap = false
                    
                    if let selectedAnnotations = self.mapView.map.selectedAnnotations as? [MapPointAnnotation]{
                        for annotation in selectedAnnotations {
                            self.mapView.map.deselectAnnotation(annotation, animated: true)
                        }
                    }
                    self.mapView.initialRegion()
                })
        }
        
    }

    func setVenueCollection(_ array: [Venue]!) {
         if let v = array {
            venues = v
            tableController.loadVenues(v)
            mapView.loadPointsWithArray(v)

        }
    }
    
    func navigateToDetail(_ notification:Notification){
        if let venue = notification.object as? Venue {
            self.detailVenue.lblName.text = venue.name
            self.detailVenue.lblAddress.text = venue.address
            self.detailVenue.lblCity.text = venue.city

        } else {
            print("no venue at TableMapController")
        }
        self.navigationController?.pushViewController(self.detailVenue, animated: true)
    }
    

}
