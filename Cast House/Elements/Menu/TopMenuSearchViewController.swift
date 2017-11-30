//
//  TopMenuSearchViewController.swift
//  Cast House
//
//  Created by Simon Degn on 08/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit

class TopMenuSearchViewController: UIViewController {

    var menu: TopMenuViewController?
    let topMenuSearchButton = UIButton()
    let topMenuSearchBar = UITextField()
    let topMenuSearchViewBG = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        topMenuSearchViewBG.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 120.0, height: 30.0)
        topMenuSearchViewBG.backgroundColor = UIColor.init(red: (240/255.0), green: (240/255.0), blue: (240/255.0), alpha: 1.0)
        topMenuSearchViewBG.layer.cornerRadius = 3.0
        topMenuSearchViewBG.clipsToBounds = true
        self.view.addSubview(topMenuSearchViewBG)
        
        topMenuSearchButton.frame = CGRect(x: -5.0, y: -5.0, width: 40.0, height: 40.0)
        topMenuSearchButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        topMenuSearchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        self.view.addSubview(topMenuSearchButton)
        
        topMenuSearchBar.isUserInteractionEnabled = true
        topMenuSearchBar.frame = CGRect(x: 34.0, y: 0, width: self.view.frame.size.width - 154.0, height: 30.0)
        topMenuSearchBar.textColor = .gray
        topMenuSearchBar.font = UIFont(name: "AsapCondensed-Medium", size: 16.0)
        topMenuSearchBar.placeholder = NSLocalizedString("Search Cast House...", comment: "")
        topMenuSearchBar.keyboardType = UIKeyboardType.default
        topMenuSearchBar.returnKeyType = UIReturnKeyType.search
        topMenuSearchBar.backgroundColor = .clear
        topMenuSearchBar.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        self.view.addSubview(topMenuSearchBar)
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        print("\(String(describing: textField.text!))")
        self.menu!.root!.searchView.updateSearchResults(searchText: textField.text!)
    }
}
