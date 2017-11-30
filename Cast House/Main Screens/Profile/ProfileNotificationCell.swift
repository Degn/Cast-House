//
//  ProfileNotificationCell.swift
//  Cast House
//
//  Created by Simon Degn on 29/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import Foundation

import UIKit
import AFNetworking

class ProfileNotificationCell: UITableViewCell {
    
    var profileNotificationCellImageview = UIImageView()
    var profileNotificationCellTextLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ProfileNotificationCell")
        
        profileNotificationCellImageview.frame = CGRect(x: 20, y: 16, width: 48, height: 48)
        profileNotificationCellImageview.backgroundColor = UIColor(red: (249/255.0), green: (249/255.0), blue: (249/255.0), alpha: 1.0)
        profileNotificationCellImageview.layer.cornerRadius = 24.0
        profileNotificationCellImageview.contentMode = .scaleAspectFill
        profileNotificationCellImageview.clipsToBounds = true
        self.addSubview(profileNotificationCellImageview)
        
        profileNotificationCellTextLabel.frame = CGRect(x: 80, y: 16, width: self.frame.size.width-70, height: 48)
        profileNotificationCellTextLabel.font = UIFont(name: "AsapCondensed-Medium", size: 14)
        profileNotificationCellTextLabel.textColor = UIColor(red: (200/255.0), green: (200/255.0), blue: (200/255.0), alpha: 1.0)
        profileNotificationCellTextLabel.numberOfLines = 2
        self.addSubview(profileNotificationCellTextLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
