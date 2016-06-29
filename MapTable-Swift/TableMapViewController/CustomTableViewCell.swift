//
//  CustomTableViewCell.swift
//  JsonTableViewSwift
//
//  Created by Gazolla on 25/09/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var venue:Venue? {
        didSet{
            self.textLabel?.text = venue?.name
            self.detailTextLabel?.text = venue?.category
            self.detailTextLabel?.textColor = .lightGrayColor()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
