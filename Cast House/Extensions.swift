//
//  Extensions.swift
//  Cast House
//
//  Created by Simon Degn on 15/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit


extension UIColor {
    static let themeColor1 = UIColor(red: CGFloat(Int(50 + arc4random_uniform(205))) / 255.0,
                                     green: CGFloat(Int(50 + arc4random_uniform(205))) / 255.0,
                                     blue: CGFloat(Int(50 + arc4random_uniform(205))) / 255.0,
                                     alpha: 1.0)
    
    static let themeColor2 = UIColor(red: CGFloat(Int(50 + arc4random_uniform(205))) / 255.0,
                                     green: CGFloat(Int(50 + arc4random_uniform(205))) / 255.0,
                                     blue: CGFloat(Int(50 + arc4random_uniform(205))) / 255.0,
                                     alpha: 1.0)
}


let imageCache = NSCache<NSString, AnyObject>()

extension String {
    
    var slugify: String {
        get {
            var newString = self.lowercased()
            // newString = newString.components(separatedBy: NSCharacterSet.alphanumerics.inverted).joined(separator: "")
            
            newString = newString.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
            
            newString = newString.replacingOccurrences(of: "[^0-9A-Za-z-]", with: "", options: .regularExpression, range: nil)
            
            while newString.range(of:"--") != nil {
                newString = newString.replacingOccurrences(of: "--", with: "-", options: .literal, range: nil)
            }
            
            while newString.hasPrefix("-") {
                newString = String(newString.dropFirst())
            }
            
            while newString.hasSuffix("-") {
                newString = String(newString.dropLast())
            }
            
            print("how it looks: \(newString)")
            
            return newString
        }
    }
}
