//
//  VenuesTableView.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class VenuesTableView: UITableViewController {
    
    var venues: [Venue] = []
    var rightButton:UIButton?
    let cellId = "cell"
    
    convenience init(frame:CGRect){
        self.init(style:.Plain)
        self.title = "Plain Table"
        self.view.frame = frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    func loadVenues(array: [Venue]) {
        self.venues = array
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.venues.count as Int
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath) as! CustomTableViewCell
        cell.venue = self.venues[indexPath.row] as Venue
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("mapViewTapped", object: nil)
        let venue:Venue = self.venues[indexPath.row] as Venue
        NSNotificationCenter.defaultCenter().postNotificationName("selectAnnotation", object: venue)
    }
    
    deinit{
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }

}
