//
//  ProfilePodcastCell.swift
//  Cast House
//
//  Created by Simon Degn on 28/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import AFNetworking

class ProfilePodcastCell: UITableViewCell {
    
    var profilePodcastCellTitleLabel = UILabel()
    var profilePodcastCellImageview = UIImageView()
    var profilePodcastCellSummaryLabel = UILabel()
    var profilePodcastCellAuthorLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ProfilePodcastCell")
        
        profilePodcastCellImageview.frame = CGRect(x: 20, y: 25, width: 60, height: 60)
        profilePodcastCellImageview.backgroundColor = UIColor(red: (249/255.0), green: (249/255.0), blue: (249/255.0), alpha: 1.0)
        profilePodcastCellImageview.layer.cornerRadius = 30.0
        profilePodcastCellImageview.contentMode = .scaleAspectFill
        profilePodcastCellImageview.clipsToBounds = true
        self.addSubview(profilePodcastCellImageview)
        
        profilePodcastCellTitleLabel.frame = CGRect(x: 100, y: 0, width: self.frame.size.width-80, height: 34)
        profilePodcastCellTitleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 18)
        profilePodcastCellTitleLabel.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        self.addSubview(profilePodcastCellTitleLabel)
        
        profilePodcastCellSummaryLabel.frame = CGRect(x: 100, y: 22, width: self.frame.size.width-80, height: 70)
        profilePodcastCellSummaryLabel.font = UIFont(name: "AsapCondensed-Medium", size: 14)
        profilePodcastCellSummaryLabel.textColor = UIColor(red: (200/255.0), green: (200/255.0), blue: (200/255.0), alpha: 1.0)
        profilePodcastCellSummaryLabel.numberOfLines = 3
        self.addSubview(profilePodcastCellSummaryLabel)
        
        profilePodcastCellAuthorLabel.frame = CGRect(x: 100, y: 84, width: self.frame.size.width-80, height: 20)
        profilePodcastCellAuthorLabel.font = UIFont(name: "AsapCondensed-Medium", size: 12)
        profilePodcastCellAuthorLabel.textColor = UIColor(red: (100/255.0), green: (100/255.0), blue: (100/255.0), alpha: 1.0)
        profilePodcastCellAuthorLabel.numberOfLines = 1
        self.addSubview(profilePodcastCellAuthorLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


