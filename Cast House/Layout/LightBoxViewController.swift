//
//  LightBoxViewController.swift
//  Cast House
//
//  Created by Simon Degn on 16/10/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit

class LightBoxViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    func addLabel(textLines: [String]) {
        var rows = [UIView]()
        let numberOfRows = textLines.count
        let yPadding = 4
        let xPadding = 2
        let rowHeight = (self.view.frame.size.height - CGFloat(3*yPadding)) / 3
        var maxLettersForLine = 0
        
        // get max letters for line
        for line in textLines {
            let l = Array(line)
            maxLettersForLine = (maxLettersForLine > l.count) ? maxLettersForLine : l.count
        }
        
        for rowIndex in 0...numberOfRows-1 {
            
            // Background
            let row = UIView()
            let y: CGFloat = CGFloat(yPadding/2+yPadding*rowIndex)+CGFloat(rowHeight*CGFloat(rowIndex))
            row.frame = CGRect(x: CGFloat(xPadding), y: y, width: self.view.frame.size.width-CGFloat(xPadding*2), height: rowHeight)
            row.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0)
            rows.append(row)
            self.view.addSubview(row)
            
            // letter boxes (for current line)
            let letters = Array(textLines[rowIndex])
            let letterBoxSpacing:CGFloat = 2.0
            var letterBoxWidth = CGFloat((CGFloat(row.frame.size.width-10)-(letterBoxSpacing * CGFloat(maxLettersForLine))) / (CGFloat(maxLettersForLine)))
            letterBoxWidth = CGFloat(ceilf(Float(letterBoxWidth)))
            let letterBoxHeight = ceilf(Float(row.frame.size.height))
            
            let initX: CGFloat = CGFloat( (CGFloat(row.frame.size.width)
                - ((letterBoxWidth*CGFloat(letters.count))
                    + (letterBoxSpacing * CGFloat(letters.count)))) / 2.0 )
            
            
            for letterIndex in 0...letters.count-1 {
                
                let letterBox = UILabel()
                letterBox.frame = CGRect(x: CGFloat(initX + CGFloat(letterBoxWidth)*CGFloat(letterIndex)) + (letterBoxSpacing * CGFloat(letterIndex)), y: CGFloat(0), width: letterBoxWidth, height: CGFloat(letterBoxHeight))
                letterBox.text = String(letters[letterIndex])
                letterBox.font = UIFont(name: "AsapCondensed-Medium", size: 20)
                letterBox.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)

                if (letterBox.text != " ") {
                    letterBox.backgroundColor = UIColor(red: (248/255.0), green: (248/255.0), blue: (248/255.0), alpha: 1.0)
                    letterBox.layer.borderWidth = 1.0
                    letterBox.layer.borderColor = UIColor(red: (230/255.0), green: (230/255.0), blue: (230/255.0), alpha: 1.0).cgColor
                    
                    letterBox.textAlignment = .center
                } else {
                    letterBox.backgroundColor = .clear
                    letterBox.layer.borderWidth = 0.0
                    letterBox.layer.borderColor = UIColor.clear.cgColor
                }
                
                row.addSubview(letterBox)
            }
        }
    }
}

