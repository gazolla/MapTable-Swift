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


    
    convenience init(){
        self.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.white
        
        navHeight = 0.0
        width = self.view.frame.size.width
        halfHeight = (self.view.frame.size.height - navHeight!)/2
        height = self.view.frame.size.height
        let labelHeight = 40.0 as CGFloat
        
        self.lblName = UILabel(frame: CGRect(x: 0, y: 90, width: width!, height: labelHeight))
        self.lblName!.numberOfLines = 1
        // self.lblName!.font = UIFont (name: "Arial", size:30.0)
        self.lblName!.adjustsFontSizeToFitWidth = true
        self.lblName!.clipsToBounds = true
        self.lblName!.backgroundColor = UIColor.clear
        self.lblName!.textColor = UIColor.black
        self.lblName!.textAlignment = NSTextAlignment.center
        
        self.lblAddress = UILabel(frame: CGRect(x: 0, y: 135, width: width!, height: labelHeight))
        self.lblAddress!.numberOfLines = 1
        // self.lblAddress!.font = UIFont (name: "Arial", size:30.0)
        self.lblAddress!.adjustsFontSizeToFitWidth = true
        self.lblAddress!.clipsToBounds = true
        self.lblAddress!.backgroundColor = UIColor.clear
        self.lblAddress!.textColor = UIColor.black
        self.lblAddress!.textAlignment = NSTextAlignment.center
        
        self.lblCity = UILabel(frame: CGRect(x: 0, y: 180, width: width!, height: labelHeight))
        self.lblCity!.numberOfLines = 1
        // self.lblCity!.font = UIFont (name: "Arial", size:30.0)
        self.lblCity!.adjustsFontSizeToFitWidth = true
        self.lblCity!.clipsToBounds = true
        self.lblCity!.backgroundColor = UIColor.clear
        self.lblCity!.textColor = UIColor.black
        self.lblCity!.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(self.lblName!)
        self.view.addSubview(self.lblAddress!)
        self.view.addSubview(self.lblCity!)

    }
}
