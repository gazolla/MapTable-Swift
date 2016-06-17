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
        self.init(style:.plain)
        self.title = "Plain Table"
        self.view.frame = frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    func loadVenues(_ array: [Venue]) {
        self.venues = array
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.venues.count as Int
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) 
        
        let venue = self.venues[(indexPath as NSIndexPath).row] as Venue
        cell.textLabel!.text = venue.name
        print("venue category: \(venue.categoryName)")
    //    cell.detailTextLabel!.text = venue.categoryName
        return cell
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)
        let cell = self.tableView.cellForRow(at: indexPath) as UITableViewCell?
        print(cell?.textLabel?.text)
        NotificationCenter.default().post(name: Notification.Name(rawValue: "mapViewTapped"), object: nil)
        let venue:Venue = self.venues[(indexPath as NSIndexPath).row] as Venue
        NotificationCenter.default().post(name: Notification.Name(rawValue: "selectAnnotation"), object: venue)
    }
}
