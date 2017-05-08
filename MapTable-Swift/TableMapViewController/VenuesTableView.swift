//
//  VenuesTableView.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class VenuesTableView: UITableViewController {
    
    var venues:[Venue]?{
        didSet{
            self.tableView.reloadData()
        }
    }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.venues?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        if let venue = self.venues?[indexPath.item] {
            cell.textLabel!.text = venue.name
            print("venue category: \(venue.category)")
        }
        return cell
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)
        let cell = self.tableView.cellForRow(at: indexPath) as UITableViewCell?
        print(cell?.textLabel?.text ?? "")

        NotificationCenter.default.post(name: Notification.Name(rawValue: "mapViewTapped"), object: nil)
        if let venue = self.venues?[indexPath.item] {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "selectAnnotation"), object: venue)
        }
    }
    
    deinit{
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }

}
