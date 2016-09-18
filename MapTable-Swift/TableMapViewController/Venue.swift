//
//  Venue.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import Foundation

struct Position {
    var lat:Double?
    var lng:Double?
    
    init(lat:Double, lng:Double){
        self.lat = lat
        self.lng = lng
    }
    
    init(){
    }
}
class Venue {
    
    var ident: String
    var name: String
    var lat: Double
    var lng: Double
    var city: String
    var address: String
    var category: String
    
    init(aIdent:String, aName: String, aAddress: String,  aCity: String, aCategory: String, aLat: Double, aLng: Double){
        ident = aIdent
        name = aName
        address = aAddress
        city = aCity
        category = aCategory
        lat = aLat
        lng = aLng
    }
    
}
