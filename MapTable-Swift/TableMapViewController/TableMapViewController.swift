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
    
    var position:Position = Position()
    let lm = CLLocationManager()
    var bigMap = false
    var venues = [Venue]()
    var navHeight:CGFloat { return 0.0 }
    var height:CGFloat { return self.view.bounds.size.height }
    var width:CGFloat { return self.view.bounds.size.width }
    var halfHeight:CGFloat { return (height - navHeight)/2}
    var firstPosition = true
    
    lazy var tableController:VenuesTableView = { [unowned self] in
        return VenuesTableView(frame: CGRectMake(0.0, self.halfHeight, self.width, self.halfHeight))
    }()
    
    lazy var mapView:MapViewController = { [unowned self] in
        return MapViewController(frame: CGRectMake(0.0, self.navHeight, self.width, self.halfHeight))
    }()
    
    lazy var tapFirstView:UIGestureRecognizer = { [unowned self] in
        return UITapGestureRecognizer(target: self, action: #selector(TableMapViewController.mapViewTapped))
    }()
    
    
    lazy var detailVenue:VenueDetailViewController = {
        return VenueDetailViewController()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init(frame:CGRect){
        self.init(nibName: nil, bundle: nil)
        title = "Map & Table"
        
        mapView.view.addGestureRecognizer(tapFirstView)
        self.view.addSubview(self.mapView.view)
        self.view.addSubview(tableController.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableMapViewController.navigateToDetail(_:)), name: "navigateToDetail", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableMapViewController.mapViewTapped), name: "mapViewTapped", object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func mapViewTapped(){
        if (!bigMap){
            UIView.animateWithDuration(0.5,
                                       delay: 0,
                                       usingSpringWithDamping: 0.4,
                                       initialSpringVelocity: 20.0,
                                       options: UIViewAnimationOptions.CurveEaseIn ,
                                       animations: {
                                        self.mapView.view.frame = CGRectMake(0.0, self.navHeight, self.width, self.height)
                                        self.mapView.map.frame = CGRectMake(0.0, self.navHeight, self.width, self.height)
                                        self.tableController.view.center = CGPointMake(self.tableController.view.center.x, self.tableController.view.center.y+self.halfHeight);
                },
                                       completion:{ (Bool)  in
                                        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TableMapViewController.reverse))
                                        self.navigationItem.leftBarButtonItem = leftBarButtonItem
                                        self.bigMap = true
            })
        }
    }
    
    func reverse(){
        if bigMap {
            UIView.animateWithDuration(0.5,
                                       delay: 0,
                                       usingSpringWithDamping: 0.4,
                                       initialSpringVelocity: 20.0,
                                       options: UIViewAnimationOptions.CurveEaseIn ,
                                       animations: {
                                        self.mapView.view.frame = CGRectMake(0.0, self.navHeight, self.width, self.halfHeight)
                                        self.mapView.map.frame = CGRectMake(0.0, self.navHeight, self.width, self.halfHeight)
                                        self.tableController.view.center = CGPointMake(self.tableController.view.center.x, self.tableController.view.center.y-self.halfHeight);
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
    
    func setVenueCollection(array: [Venue]!) {
        dispatch_async(dispatch_get_main_queue()) {
            if let array = array {
                self.venues = array
                self.tableController.loadVenues(array)
                self.mapView.loadPointsWithArray(array)
            }
        }
    }
    
    func navigateToDetail(notification:NSNotification){
        
        if let venue:Venue = notification.object as? Venue {
            self.detailVenue.lblName?.text = venue.name
            self.detailVenue.lblAddress?.text = venue.address
            self.detailVenue.lblCity?.text = venue.city
        } else {
            print("no venue at TableMapController")
        }
        self.navigationController?.pushViewController(self.detailVenue, animated: true)
        
    }
    
    func loadDataErrorMessage(error:NSError){
        dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: "Error - \(error.code)", message: error.localizedDescription, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: {})
            })
            
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: {})
        }
    }
    
}