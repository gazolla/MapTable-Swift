//
//  VenuesTableView.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIkit

class VenuesTableView: UITableViewController,UITableViewDelegate, UITableViewDataSource {
    
    var venues: [Venue] = []
    var rightButton:UIButton?
    
     
    convenience init(frame:CGRect){
        self.init(style:.Plain)
        self.title = "Plain Table"
        self.view.frame = frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func loadVenues(array: [Venue]) {
        self.venues = array
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.venues.count as Int
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell!
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        var venue = self.venues[indexPath.row] as Venue
        cell.textLabel!.text = venue.name
        cell.detailTextLabel!.text = venue.categoryName
        return cell
    }
    
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?
        println(cell?.textLabel?.text)
        NSNotificationCenter.defaultCenter().postNotificationName("mapViewTapped", object: nil)
        let venue:Venue = self.venues[indexPath.row] as Venue
        NSNotificationCenter.defaultCenter().postNotificationName("selectAnnotation", object: venue)
    }
}
