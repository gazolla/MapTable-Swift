//
//  VeuneDetailViewController.swift
//  MapTable-Swift
//
//  Created by Gazolla on 02/08/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class VenueDetailViewController: UIViewController {
    
    var lblName:UILabel?
    var lblLatitude:UILabel?
    var lblLongitude:UILabel?
    var lblCity: UILabel?
    var lblAddress: UILabel?
    var lblCategoryName: UILabel?

    var navHeight:CGFloat?
    var width:CGFloat?
    var halfHeight:CGFloat?
    var height:CGFloat?


    
     override func viewDidLoad() {
        
        navHeight = 0.0
        width = self.view.frame.size.width
        halfHeight = (self.view.frame.size.height - navHeight!)/2
        height = self.view.frame.size.height
        let labelHeight = 40.0 as CGFloat
        
        self.lblName = UILabel(frame: CGRectMake(0, 45, width!, labelHeight))
        self.lblName!.numberOfLines = 1
        // self.lblName!.font = UIFont (name: "Arial", size:30.0)
        self.lblName!.adjustsFontSizeToFitWidth = true
        self.lblName!.clipsToBounds = true
        self.lblName!.backgroundColor = UIColor.clearColor()
        self.lblName!.textColor = UIColor.blackColor()
        self.lblName!.textAlignment = NSTextAlignment.Center
        
        self.lblAddress = UILabel(frame: CGRectMake(0, 90, width!, labelHeight))
        self.lblAddress!.numberOfLines = 1
        // self.lblAddress!.font = UIFont (name: "Arial", size:30.0)
        self.lblAddress!.adjustsFontSizeToFitWidth = true
        self.lblAddress!.clipsToBounds = true
        self.lblAddress!.backgroundColor = UIColor.clearColor()
        self.lblAddress!.textColor = UIColor.blackColor()
        self.lblAddress!.textAlignment = NSTextAlignment.Center
        
        self.lblCity = UILabel(frame: CGRectMake(0, 135, width!, labelHeight))
        self.lblCity!.numberOfLines = 1
        // self.lblCity!.font = UIFont (name: "Arial", size:30.0)
        self.lblCity!.adjustsFontSizeToFitWidth = true
        self.lblCity!.clipsToBounds = true
        self.lblCity!.backgroundColor = UIColor.clearColor()
        self.lblCity!.textColor = UIColor.blackColor()
        self.lblCity!.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(self.lblName!)
        self.view.addSubview(self.lblAddress!)
        self.view.addSubview(self.lblCity!)

    }
}
