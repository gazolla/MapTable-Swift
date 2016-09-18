//
//  AppDelegate.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let v = Venue(aIdent:"1", aName: "Whole Foods Market", aAddress: "20955 Stevens Creek Blvd", aCity: "Cupertino", aCategory: "Grocery Store", aLat: 37.323551, aLng: -122.039653)
        let v2 = Venue(aIdent:"2", aName: "Buffalo Wild Wings Grill & Bar", aAddress: "1620 Saratoga Ave", aCity: "San Jose", aCategory: "American Restaurant", aLat: 37.2979039, aLng: -121.988112)
        let v3 = Venue(aIdent:"3", aName: "Bierhaus", aAddress: "383 Castro St", aCity: "Mountain View", aCategory: "Gastropub", aLat: 37.3524382, aLng: -121.9582429)
        let v4 = Venue(aIdent:"4", aName: "Singularity University", aAddress: "Building 20 S. Akron Rd.", aCity: "Moffett Field", aCategory: "University", aLat: 37.3996033, aLng:-122.0784488)
        let v5 = Venue(aIdent:"5", aName: "Menlo Country Club", aAddress: "", aCity: "Woodside", aCategory: "Country Club", aLat: 37.4823348, aLng: -122.2406688)
        let v6 = Venue(aIdent:"6", aName: "Denny's", aAddress: "1015 Blossom Hill Rd", aCity: "San Jose", aCategory: "American Restaurant", aLat: 37.2384776, aLng: -121.8007709)
        let v7 = Venue(aIdent:"7", aName: "Refuge", aAddress: "963 Laurel St", aCity: "San Carlos", aCategory: "Restaurant", aLat: 37.5041949, aLng: -122.2695079)

        var venuesArr = [Venue]()
        venuesArr.append(v)
        venuesArr.append(v2)
        venuesArr.append(v3)
        venuesArr.append(v4)
        venuesArr.append(v5)
        venuesArr.append(v6)
        venuesArr.append(v7)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let frame =  self.window!.bounds
        
        let vtv:TableMapViewController = TableMapViewController(frame: frame)
        vtv.setVenueCollection(venuesArr)
        let nav:UINavigationController = UINavigationController(rootViewController: vtv)
        
        self.window!.rootViewController =  nav
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

