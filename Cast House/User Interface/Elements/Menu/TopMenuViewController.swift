//
//  TopMenuViewController.swift
//  Cast House
//
//  Created by Simon Degn on 07/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit

class TopMenuViewController: UIViewController {

    var topMenu = UIView()
    var root: RootViewController? 
    var topMenuSearchView = TopMenuSearchViewController()
    var topMenuLogoIcon = TopMenuLogo()
    var topMenuProfileIcon = UIButton()
    var topMenuScaleOneWidth:Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Top Menu
        //topMenu.isUserInteractionEnabled = false
        topMenu.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70.0)
        topMenu.backgroundColor = .white
        self.view.addSubview(topMenu)
        
        topMenu.layer.masksToBounds = false
        topMenu.layer.shadowColor = UIColor(red: (230/255.0), green: (230/255.0), blue: (230/255.0), alpha: 1.0).cgColor
        topMenu.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        topMenu.layer.shadowOpacity = 1.0
        topMenu.layer.shadowRadius = 0.0

        topMenuLogoIcon.setLogo()
        topMenuLogoIcon.frame = CGRect(x: 0, y: 17, width: 104, height: 50)
        topMenuLogoIcon.center.x = self.view.center.x
        topMenuLogoIcon.addTarget(self, action: #selector(logoClick), for: .touchUpInside)
        self.view.addSubview(topMenuLogoIcon)
        topMenuScaleOneWidth = Double(topMenuLogoIcon.frame.width)
        
        topMenuProfileIcon.frame = CGRect(x: 18, y: 32, width: 22, height: 22)
        topMenuProfileIcon.layer.cornerRadius = 11
        topMenuProfileIcon.clipsToBounds = true
        topMenuProfileIcon.setBackgroundImage(#imageLiteral(resourceName: "user"), for: .normal)
        topMenuProfileIcon.addTarget(self, action: #selector(profileClick), for: .touchUpInside)
        self.view.addSubview(topMenuProfileIcon)
        
        topMenuSearchView.menu = self
        topMenuSearchView.view.frame = CGRect(x: self.view.frame.size.width - 38.0,
                                              y: 28.0,
                                              width: self.view.frame.size.width - 120.0,
                                              height: 26.0)
        topMenuSearchView.view.isUserInteractionEnabled = true
        topMenuSearchView.topMenuSearchButton.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        self.view.addSubview(topMenuSearchView.view)
    }
    
    @objc func profileClick(sender: UIButton?) {
        print("profile click")
        root!.rootScroolView.setContentOffset(CGPoint(x: 0, y: (root!.rootScroolView.contentOffset.y)), animated: true)
    }
    
    @objc func searchClick(sender: UIButton?) {
        
        print("search click")
        root!.rootScroolView.setContentOffset(CGPoint(x: (root!.rootScroolView.frame.size.width * CGFloat(2)), y: (root!.rootScroolView.contentOffset.y)), animated: true)
    }
    
    @objc func logoClick(sender: UIButton?) {
        print("logo click")
        root!.rootScroolView.setContentOffset(CGPoint(x: (root!.rootScroolView.frame.size.width * CGFloat(1)), y: (root!.rootScroolView.contentOffset.y)), animated: true)

    }

    func moveMenuFocus(positionPercentage: CGFloat ) {
        
        print("positionPercentage: \(positionPercentage)")
        
        // LOGO
        let frameLeftCenterX = Double(42.0)
        let frameCenterCenterX = Double(self.view.frame.size.width/2)
        let frameRightCenterX = Double(self.view.frame.size.width - 16.0)

        var posX = 0.0
        var labelAlpha = ((positionPercentage) / 50)

        // logo going left
        posX = frameCenterCenterX + ((frameRightCenterX - frameCenterCenterX) * ( 1 - Double(labelAlpha)))

        if (positionPercentage > 50) {
            // logo going right
            labelAlpha = 1 - (((positionPercentage) / 50) - 1)
            posX = frameCenterCenterX - ((frameCenterCenterX - frameLeftCenterX) * ( 1 - Double(labelAlpha)))
        }

        let scale: Double = Double(0.6 + (0.4 * labelAlpha))
        topMenuLogoIcon.center = CGPoint(x: posX, y: Double(topMenuLogoIcon.center.y))
        topMenuLogoIcon.topMenuLogoLabelLower.alpha = CGFloat(labelAlpha)
        topMenuLogoIcon.topMenuLogoLabelUpper.alpha = CGFloat(labelAlpha)
        topMenuLogoIcon.transform = CGAffineTransform(scaleX:CGFloat(scale), y: CGFloat(scale))
        
        // PROFILE IMAGE
        let profileImageFrameLeftCenterX = -Double(self.view.frame.size.width/2)
        let profileImageFrameCenterCenterX = 29.0
        let profileImageFrameRightCenterX = Double(self.view.frame.size.width/2)
        var profileImagePosX = 0.0
        
        // profile image going left
        profileImagePosX = profileImageFrameCenterCenterX + ((profileImageFrameRightCenterX - profileImageFrameCenterCenterX) * ( 1 - Double(labelAlpha)))
        
        if (positionPercentage > 50) {
            // profile image going right
            profileImagePosX = profileImageFrameCenterCenterX - ((profileImageFrameCenterCenterX - profileImageFrameLeftCenterX) * ( 1 - Double(labelAlpha)))
        }
        
        let profileImageScale: Double = Double(1.5 - (0.5 * labelAlpha))
        let profileImageAlpha: Double = Double(1.0 - (0.5 * labelAlpha))
        topMenuProfileIcon.transform = CGAffineTransform(scaleX:CGFloat(profileImageScale), y: CGFloat(profileImageScale))
        topMenuProfileIcon.alpha = CGFloat(profileImageAlpha)
        topMenuProfileIcon.center = CGPoint(x: profileImagePosX, y: Double(topMenuProfileIcon.center.y))

        // SEARCH
        let searchFrameLeftCenterX:Double = Double(self.view.frame.size.width/2)
        let searchFrameCenterCenterX:Double = Double(self.view.frame.size.width + (topMenuSearchView.view.frame.width/2) - 38.0)
        let searchFrameRightCenterX:Double = Double(self.view.frame.size.width) + Double(self.view.frame.size.width/2)
        var searchPosX = 0.0
        
        // search going left
        searchPosX = searchFrameCenterCenterX + (Double(searchFrameRightCenterX - searchFrameCenterCenterX) * ( 1 - Double(labelAlpha)))
        
        if (positionPercentage > 50) {
            // search going right
            searchPosX = searchFrameCenterCenterX - ((searchFrameCenterCenterX - searchFrameLeftCenterX) * ( 1 - Double(labelAlpha)))
        }
        
        let searchScale: Double = Double(0.9 + (0.1 * (1.0 - labelAlpha)))
        let searchTopMargin: Double = Double(1.0 * (1.0 - labelAlpha))
        let searchAlpha: Double = Double(0.5 + (0.5 * (1.0 - labelAlpha)))
        
        topMenuSearchView.view.frame.size.height = 26.0
        topMenuSearchView.view.frame.origin.y = 28.0
        topMenuSearchView.view.transform = CGAffineTransform(scaleX:CGFloat(searchScale), y: CGFloat(searchScale))
        topMenuSearchView.view.alpha = CGFloat(searchAlpha)
        topMenuSearchView.topMenuSearchBar.alpha = CGFloat(1.0 - labelAlpha)
        topMenuSearchView.topMenuSearchViewBG.alpha = CGFloat(1.0 - labelAlpha)
        topMenuSearchView.view.center = CGPoint(x: searchPosX, y: 41.0)

    }
}
