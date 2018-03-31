//
//  VenuesTableView.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class VenuesTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var venues:[Venue]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var delegate:MainViewControllerDelegate?
    var mapDelegate: VenuesMapControllerDelegate?
    
    let cellId = "cell"
    
    lazy var tableView: UITableView = { [unowned self] in
        let c = UITableView()
        c.backgroundColor = UIColor.Gainsboro
        c.translatesAutoresizingMaskIntoConstraints = false
        c.delegate = self
        c.dataSource = self
        c.register(VenueCell.self, forCellReuseIdentifier: self.cellId)
        return c
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let layout = self.view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: layout.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.venues?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! VenueCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = .detailButton
        if let venue = self.venues?[indexPath.item] {
            cell.venue = venue
            print("venue category: \(venue.category)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let venue = self.venues?[indexPath.item]{
            delegate?.navigateToDetail(venue)
        }
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)
        if let cell = self.tableView.cellForRow(at: indexPath) as! VenueCell?{
            print(cell.textLabel?.text ?? "")
            
            delegate?.reverseMap(cell)
            
            if let venue = self.venues?[indexPath.item] {
                mapDelegate?.selectAnnotation(venue)
            }

        }
    }
    
    deinit{
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }

}

class VenueCell: UITableViewCell {
    
    var venue:Venue? {
        didSet{
            self.textLabel?.text = venue?.name
            self.detailTextLabel?.text = venue?.category
            self.detailTextLabel?.textColor = .lightGray
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

