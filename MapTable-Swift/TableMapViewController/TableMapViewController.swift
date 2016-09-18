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
        return VenuesTableView(frame: CGRect(x: 0.0, y: self.halfHeight, width: self.width, height: self.halfHeight))
    }()
    
    lazy var mapView:MapViewController = { [unowned self] in
        return MapViewController(frame: CGRect(x: 0.0, y: self.navHeight, width: self.width, height: self.halfHeight))
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(TableMapViewController.navigateToDetail(_:)), name: NSNotification.Name(rawValue: "navigateToDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TableMapViewController.mapViewTapped), name: NSNotification.Name(rawValue: "mapViewTapped"), object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
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
        DispatchQueue.main.async {
            if let array = array {
                self.venues = array
                self.tableController.loadVenues(array)
                self.mapView.loadPointsWithArray(array)
            }
        }
    }
    
    func navigateToDetail(_ notification:Notification){
        
        if let venue:Venue = notification.object as? Venue {
            self.detailVenue.lblName?.text = venue.name
            self.detailVenue.lblAddress?.text = venue.address
            self.detailVenue.lblCity?.text = venue.city
        } else {
            print("no venue at TableMapController")
        }
        self.navigationController?.pushViewController(self.detailVenue, animated: true)
        
    }
    
    func loadDataErrorMessage(_ error:NSError){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error - \(error.code)", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert:UIAlertAction) -> Void in
                alertController.dismiss(animated: true, completion: {})
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: {})
        }
    }
    
}
