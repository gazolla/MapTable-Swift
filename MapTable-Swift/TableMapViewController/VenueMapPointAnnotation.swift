//
//  MapPointAnnotation.swift
//  MapTable-Swift
//
//  Created by Gazolla on 29/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit
import MapKit

class VenueMapPointAnnotation : MKPointAnnotation {
    
    var venue:Venue?
  
    deinit{
        self.venue = nil
    }
}


