//
//  DetailShowEpisodeViewCell.swift
//  Cast House
//
//  Created by Simon Degn on 18/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import AFNetworking

class DetailShowEpisodeViewCell: UITableViewCell {

    var episodeTitleLabel = UILabel()
    var episodeImageview = UIImageView()
    var episodePlayButton = UIButton()
    var episodeDescriptionLabel = UILabel()
    var episodePublishDateLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "EpisodeCell")
        
        episodeImageview.frame = CGRect(x: 20, y: 25, width: 60, height: 60)
        episodeImageview.backgroundColor = UIColor(red: (249/255.0), green: (249/255.0), blue: (249/255.0), alpha: 1.0)
        episodeImageview.layer.cornerRadius = 30.0
        episodeImageview.clipsToBounds = true
        self.addSubview(episodeImageview)
        
        episodePlayButton.frame = CGRect(x: 20, y: 25, width: 60, height: 60)
        episodePlayButton.backgroundColor = .clear
        self.addSubview(episodePlayButton)

        episodeTitleLabel.frame = CGRect(x: 100, y: 0, width: self.frame.size.width-80, height: 40)
        episodeTitleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 18)
        episodeTitleLabel.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        self.addSubview(episodeTitleLabel)
        
        episodeDescriptionLabel.frame = CGRect(x: 100, y: 30, width: self.frame.size.width-80, height: 70)
        episodeDescriptionLabel.font = UIFont(name: "AsapCondensed-Medium", size: 14)
        episodeDescriptionLabel.textColor = UIColor(red: (200/255.0), green: (200/255.0), blue: (200/255.0), alpha: 1.0)
        episodeDescriptionLabel.numberOfLines = 3
        self.addSubview(episodeDescriptionLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
