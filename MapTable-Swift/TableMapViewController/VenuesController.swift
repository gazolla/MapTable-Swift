//
//  MainViewController.swift
//  BlockViewAnimation
//
//  Created by Gazolla on 29/03/2018.
//  Copyright © 2018 Gazolla. All rights reserved.
//

import UIKit
import MapKit

protocol MainViewControllerDelegate {
    func reverseMap(_ sender:UIAppearance)
    func navigateToDetail(_ venue:Venue)
}

class VenuesController: UIViewController, MainViewControllerDelegate {
    var bigMap = false

    var venues:[Venue]?{
        didSet{
            if venues != nil {
                tableView.venues = venues
                mapView.loadPointsWithArray(venues!)
            }
        }
    }
    
    lazy var mapView:VenuesMapController = {
        let m =  VenuesMapController()
        m.delegate = self
        m.view.layer.masksToBounds = false
        m.view.layer.shadowColor = UIColor.gray.cgColor
        m.view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        m.view.layer.shadowRadius = 2.0
        m.view.layer.shadowOpacity = 1.0
        m.view.addGestureRecognizer(self.tapFirstView)
        return m
    }()
    
    lazy var tapFirstView:UIGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(reverseMap))
    }()

    lazy var tableView:VenuesTableController = {
        let v = VenuesTableController()
        v.delegate = self
        v.mapDelegate = mapView
        v.view.layer.masksToBounds = false
        v.view.layer.shadowColor = UIColor.gray.cgColor
        v.view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        v.view.layer.shadowRadius = 2.0
        v.view.layer.shadowOpacity = 1.0
        return v
    }()
    
    lazy var detailVenue:VenueDetailViewController = {
        return VenueDetailViewController()
    }()

    lazy var stack:UIStackView = {
        let s = UIStackView(frame:CGRect.zero)
        s.alignment = .fill
        s.distribution = .fillEqually
        s.axis = .vertical
        s.addArrangedSubview(mapView.view)
        s.addArrangedSubview(tableView.view)
        s.spacing = 5
        s.translatesAutoresizingMaskIntoConstraints = false
        return s

    }()
    
    lazy var leftButton:UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(reverseMap))
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Gainsboro
        view.addSubview(stack)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let layout = self.view.layoutMarginsGuide
        stack.topAnchor.constraint(equalTo: layout.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewRespectsSystemMinimumLayoutMargins = false
        view.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func navigateToDetail(_ venue: Venue) {
        self.detailVenue.lblName.text = venue.name
        self.detailVenue.lblAddress.text = venue.address
        self.detailVenue.lblCity.text = venue.city
        self.navigationController?.pushViewController(self.detailVenue, animated: true)
    }
    
    
    @objc func reverseMap(_ sender:UIAppearance){
        
        if bigMap && sender is UITapGestureRecognizer { return }

        if (!bigMap){
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 20.0,
                           options: UIViewAnimationOptions.curveEaseIn ,
                           animations: {
                            self.tableView.view.isHidden = true
            },
                           completion:{ (Bool)  in
                            self.navigationItem.leftBarButtonItem = self.leftButton
                            self.bigMap = true
            })
            
        } else {
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 20.0,
                           options: UIViewAnimationOptions.curveEaseIn ,
                           animations: {
                            self.tableView.view.isHidden = false
            },
                           completion:{ (Bool)  in
                            self.navigationItem.leftBarButtonItem = nil
                            self.bigMap = false
                            if let selectedAnnotations = self.mapView.map.selectedAnnotations as? [VenueMapPointAnnotation]{
                                for annotation in selectedAnnotations {
                                    self.mapView.map.deselectAnnotation(annotation, animated: true)
                                }
                            }
                            self.mapView.initialRegion()
            })

            
        }
    }
}

extension UIColor {
    
    static let Gainsboro = UIColor(hex: "0xDCDCDC")
    static let Snow = UIColor(hex: "0xFFFAFA")
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
