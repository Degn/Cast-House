//
//  DetailViewController.swift
//  Cast House
//
//  Created by Simon Degn on 15/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase

class DetailContainerViewController: UIViewController {

    var detailRoot: DetailRootViewController?
    var backButton = UIButton()
    var titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 6.0
        self.view.clipsToBounds = true
        
        // Back button
        backButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        backButton.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(12, 16, 12, 12);
        backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        // Title label
        titleLabel.frame = CGRect(x: 50.0, y: 0, width: self.view.frame.size.width - 66.0, height: 48.0)
        titleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 20)
        titleLabel.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        titleLabel.text = ""
        self.view.addSubview(titleLabel)
        
    }
    
    
    func setShowDetail(showObject: ShowObject) {
        
        if showObject.title != "" && showObject.author != "" {
            
            let detailShowViewController = DetailShowViewController()
            detailShowViewController.container = self
            detailShowViewController.view.frame = CGRect(x: 0.0, y: 50.0, width: self.view.frame.width, height: self.view.frame.height-50)
            detailShowViewController.view.clipsToBounds = true
            self.view.addSubview(detailShowViewController.view)
            self.addChildViewController(detailShowViewController)
            
            // SET SHOW (preloaded)
            titleLabel.text = showObject.title
            detailShowViewController.view.isHidden = false
            detailShowViewController.view.isUserInteractionEnabled = true
            detailShowViewController.setDetailFromShowObject(showObject: showObject)
        
        } else {
            
            // LOAD SHOW (not preloaded)
            let db = Firestore.firestore()
            let key = showObject.id
            
            db.collection("shows").document(key).getDocument { (doc, error) in
                
                let detailShowViewController = DetailShowViewController()
                detailShowViewController.container = self
                detailShowViewController.view.frame = CGRect(x: 0.0, y: 50.0, width: self.view.frame.width, height: self.view.frame.height-50)
                detailShowViewController.view.clipsToBounds = true
                self.view.addSubview(detailShowViewController.view)
                self.addChildViewController(detailShowViewController)
                
                let document = doc!.data()
                showObject.updateInfo(document: doc!, updateImage: true)
                self.titleLabel.text = document["title"] as? String
                detailShowViewController.view.isHidden = false
                detailShowViewController.view.isUserInteractionEnabled = true
                detailShowViewController.setDetailFromShowObject(showObject: showObject)
            }
            
        }
    }
    
    
    func setPublisherDetail(showObject: ShowObject) {
        
        let detailPublisherViewController = DetailPublisherViewController()
        detailPublisherViewController.container = self
        detailPublisherViewController.view.frame = CGRect(x: 0.0, y: 50.0, width: self.view.frame.width, height: self.view.frame.height-50)
        detailPublisherViewController.view.clipsToBounds = true
        self.view.addSubview(detailPublisherViewController.view)
        self.addChildViewController(detailPublisherViewController)

        titleLabel.text = showObject.title
        detailPublisherViewController.view.isHidden = false
        detailPublisherViewController.view.isUserInteractionEnabled = true
       //  detailPublisherViewController.setDetail(showObject: showObject)
    }
    
    
    func setEpisodeDetail(episodeObject: EpisodeObject) {
        
        let detailEpisodeViewController = DetailEpisodeViewController()
        detailEpisodeViewController.container = self
        detailEpisodeViewController.view.frame = CGRect(x: 0.0, y: 50.0, width: self.view.frame.width, height: self.view.frame.height-50)
        detailEpisodeViewController.view.clipsToBounds = true
        self.view.addSubview(detailEpisodeViewController.view)
        self.addChildViewController(detailEpisodeViewController)

        titleLabel.text = episodeObject.title
        detailEpisodeViewController.view.isHidden = false
        detailEpisodeViewController.view.isUserInteractionEnabled = true
        detailEpisodeViewController.setDetail(episodeObject: episodeObject)
    }
    
    @objc private func back(_ sender: UIButton?) {
        detailRoot?.goBack()
    }
}
