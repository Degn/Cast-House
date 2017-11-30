//
//  TopMenuLogo.swift
//  Cast House
//
//  Created by Simon Degn on 11/10/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit

class TopMenuLogo: UIButton {
    
    var topMenuLogoOuterCircle = UIView()
    var topMenuLogoInnerCircle = UIView()
    var topMenuLogoLabelUpper = UILabel()
    var topMenuLogoLabelLower = UILabel()
    var colorTop = UIColor()
    var colorBottom = UIColor()

     func setLogo() {
        
        // Set colorful ring - The logo
        let gl:CAGradientLayer!
        
        
        self.frame = CGRect(x: 0, y: 0, width: 104, height: 50)
        
        topMenuLogoOuterCircle.frame = CGRect(x: 7, y: 7, width: 40, height: 40)
        topMenuLogoOuterCircle.layer.cornerRadius = 20
        topMenuLogoOuterCircle.clipsToBounds = true
        topMenuLogoOuterCircle.layer.bounds = topMenuLogoOuterCircle.frame;
        
        gl = CAGradientLayer()
        gl.colors = [UIColor.themeColor1.cgColor, UIColor.themeColor2.cgColor]
        gl.startPoint = CGPoint(x: 0.5, y: 1.0)
        gl.endPoint = CGPoint(x: 1.0, y: 0.5)
        gl.frame = topMenuLogoOuterCircle.frame
        topMenuLogoOuterCircle.layer.addSublayer(gl)
        topMenuLogoOuterCircle.layer.masksToBounds = true;
        self.addSubview(topMenuLogoOuterCircle)
        
        topMenuLogoInnerCircle.frame = CGRect(x: 14, y: 14, width: 26, height: 26)
        topMenuLogoInnerCircle.layer.cornerRadius = 13
        topMenuLogoInnerCircle.clipsToBounds = true
        topMenuLogoInnerCircle.backgroundColor = .white
        topMenuLogoOuterCircle.addSubview(topMenuLogoInnerCircle)
        
        // Upper label
        topMenuLogoLabelUpper.frame = CGRect(x: 52, y: 6, width: 70, height: 24)
        topMenuLogoLabelUpper.text = "CAST"
        topMenuLogoLabelUpper.font = UIFont(name: "AsapCondensed-Medium", size: 17)
        topMenuLogoLabelUpper.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        self.addSubview(topMenuLogoLabelUpper)

        // Lower label
        topMenuLogoLabelLower.frame = CGRect(x: 52, y: 22, width: 70, height: 24)
        topMenuLogoLabelLower.text = "HOUSE"
        topMenuLogoLabelLower.font = UIFont(name: "AsapCondensed-Medium", size: 17)
        topMenuLogoLabelLower.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        self.addSubview(topMenuLogoLabelLower)
    }
}
