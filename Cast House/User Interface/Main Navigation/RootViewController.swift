//
//  RootViewController.swift
//  Cast House
//
//  Created by Simon Degn on 11/10/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase

class RootViewController: UIViewController, UIScrollViewDelegate {
    
    var menu = TopMenuViewController()
    var rootScroolView = UIScrollView()
    var profileView = ProfileViewController()
    var feedView = FeedViewController()
    var searchView = SearchViewController()
    var loginView = LoginViewController()
    var currentUser = CurrentUser()
    var themeColor1 = UIColor()
    var themeColor2 = UIColor()
    var baseView = UIView()
    var detailRootView = DetailRootViewController()
    var player = PlayerView()
    var darkOverlay = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser.getUserInfo()

        loggedOut()
        
        self.view.backgroundColor = .white
        self.view.layer.bounds = self.view.frame;
        let gl = CAGradientLayer()
        gl.colors = [UIColor.themeColor1.cgColor, UIColor.themeColor2.cgColor]
        gl.startPoint = CGPoint(x: 0.5, y: 1.0)
        gl.endPoint = CGPoint(x: 1.0, y: 0.5)
        gl.opacity = 0.4
        gl.frame = self.view.frame
        self.view.layer.addSublayer(gl)
        self.view.layer.masksToBounds = true;

        // Base
        baseView.frame = self.view.frame
        self.view.addSubview(baseView)
        
        // Top Menu
        menu.root = self
        menu.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70.0)
        baseView.addSubview(menu.view)
        themeColor1 = menu.topMenuLogoIcon.colorTop
        themeColor1 = menu.topMenuLogoIcon.colorBottom
        
        // Root Scroll View
        rootScroolView.frame = CGRect(x: 0, y: menu.view.frame.size.height, width: baseView.frame.size.width, height: baseView.frame.size.height - menu.view.frame.size.height)
        rootScroolView.backgroundColor = .white
        rootScroolView.contentSize = CGSize(width: 3 * self.view.frame.size.width, height: rootScroolView.frame.size.height)
        rootScroolView.contentOffset = CGPoint(x: 1 * self.view.frame.size.width, y: 0)
        rootScroolView.isPagingEnabled = true
        rootScroolView.alwaysBounceHorizontal = false
        rootScroolView.delegate = self
        rootScroolView.showsHorizontalScrollIndicator = false
        baseView.addSubview(rootScroolView)
        
        // Profile View
        profileView.root = self
        profileView.view.frame = CGRect(x: 0 * self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: rootScroolView.frame.size.height)
        rootScroolView.addSubview(profileView.view)
        
        // Feed View
        feedView.root = self
        feedView.view.frame = CGRect(x: 1 * self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: rootScroolView.frame.size.height)
        rootScroolView.addSubview(feedView.view)
        
        // Search View
        searchView.root = self
        searchView.view.frame = CGRect(x: 2 * self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: rootScroolView.frame.size.height)
        rootScroolView.addSubview(searchView.view)
        
        // Login View
        loginView.root = self
        loginView.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        baseView.addSubview(loginView.view)
        
        // Detail
        detailRootView.root = self
        detailRootView.view.frame =  CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        detailRootView.view.backgroundColor = .clear
        detailRootView.view.alpha = 0.0
        detailRootView.view.isUserInteractionEnabled = false
        detailRootView.view.layer.cornerRadius = 6.0
        detailRootView.view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        detailRootView.view.transform = CGAffineTransform(translationX: 0.0, y: (self.view.frame.height/2))
        self.view.addSubview(detailRootView.view)
        
        // Dark overlay
        darkOverlay.frame = self.view.frame
        darkOverlay.backgroundColor = .black
        darkOverlay.alpha = 0.0
        darkOverlay.isUserInteractionEnabled = false
        darkOverlay.addTarget(self, action: #selector(closePlayerDetail), for: .touchUpInside)
        self.view.addSubview(darkOverlay)
        
        // Player
        player.root = self
        player.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.width, height: 55)
        player.setPlayer()
        self.view.addSubview(player)
        
        // Check if user is logged in
        if currentUser.isLoggedIn() {
            loggedIn()
        } else {
            loggedOut()
        }
        

    }
    
    
    func enterDetailMode(typeOfDetailItem: String, parameter: Any?) {
        
        detailRootView.setDetail(typeOfDetailItem: typeOfDetailItem,
                                 parameter: parameter,
                                 animated: false)

        UIView.animate(withDuration: 0.18) {
            self.baseView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.detailRootView.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.detailRootView.view.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            self.baseView.center = self.view.center
            self.baseView.alpha = 0.0
            self.detailRootView.view.alpha = 1.0
            self.detailRootView.view.isUserInteractionEnabled = true
            self.baseView.isUserInteractionEnabled = false
            self.baseView.layer.cornerRadius = 6.0
            self.baseView.clipsToBounds = true
        }
    }

    
    func exitDetailMode() {
        UIView.animate(withDuration: 0.18) {
            self.baseView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.detailRootView.view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            self.detailRootView.view.transform = CGAffineTransform(translationX: 0.0, y: (self.view.frame.height/2))
            self.baseView.center = self.view.center
            self.baseView.alpha = 1.0
            self.detailRootView.view.alpha = 0.0
            self.detailRootView.view.isUserInteractionEnabled = false
            self.baseView.isUserInteractionEnabled = true
            self.baseView.layer.cornerRadius = 0.0
            self.baseView.clipsToBounds = true
        }
    }
    
    
    func openPlayer(episodeObject: EpisodeObject) {
        
        UIView.animate(withDuration: 0.2) {
            self.player.frame = CGRect(x: 0, y: self.view.frame.size.height-55, width: self.view.frame.width, height: 55)
            
            self.detailRootView.view.frame =  CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 55.0)

            var index = 0
            for dv in self.detailRootView.detailViews {
                dv.view.frame = CGRect(x: 8.0 + (self.detailRootView.view.frame.width * CGFloat(index)), y: 20.0, width: self.detailRootView.view.frame.width-16.0, height: self.detailRootView.view.frame.height-28.0)
                index += 1
            }
        }
        player.updateEpisodeInfo(episodeObject: episodeObject)
    }
    
    
    func openPlayerDetail(episodeObject: EpisodeObject) {
        darkOverlay.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.18) {
            self.darkOverlay.alpha = 0.7
            self.player.frame = CGRect(x: 0, y: self.view.frame.size.height-350, width: self.view.frame.width, height: 350)
        }
    }
    
    
    @objc func closePlayerDetail() {
        print("CLOSING EPISODE DETAIL VIEW")
        darkOverlay.isUserInteractionEnabled = false
        player.closeEpisodeDetailView()
        
        UIView.animate(withDuration: 0.18) {
            self.darkOverlay.alpha = 0.0
            self.player.frame = CGRect(x: 0, y: self.view.frame.size.height-55, width: self.view.frame.width, height: 55)
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menu.moveMenuFocus(positionPercentage: (scrollView.contentOffset.x) / (scrollView.contentSize.width - self.view.frame.size.width) * 100)
        
        if (scrollView.contentOffset.x > 0) {
            if (scrollView.contentOffset.x < self.view.frame.size.width) {
                profileView.view.alpha = 1.0 - (scrollView.contentOffset.x / (self.view.frame.size.width))
                feedView.view.alpha = (scrollView.contentOffset.x / (self.view.frame.size.width))
                searchView.view.alpha = 0.0
            } else if (scrollView.contentOffset.x > self.view.frame.size.width && scrollView.contentOffset.x < self.view.frame.size.width*2) {
                profileView.view.alpha = 0.0
                feedView.view.alpha = 1.0 - ((scrollView.contentOffset.x - self.view.frame.size.width) / (self.view.frame.size.width))
                searchView.view.alpha = ((scrollView.contentOffset.x - self.view.frame.size.width) / (self.view.frame.size.width))
            }
        }
        
    }
    
    
    func loggedOut() {
        loginView.view.isHidden = false
        rootScroolView.isHidden = true
        profileView.view.isHidden = true
        feedView.view.isHidden = true
        searchView.view.isHidden = true
    }
    
    
    func loggedIn() {
        loginView.view.isHidden = true
        rootScroolView.isHidden = false
        profileView.view.isHidden = false
        feedView.view.isHidden = false
        searchView.view.isHidden = false
    }
}

