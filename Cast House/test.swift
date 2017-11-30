//
//  ViewController.swift
//  Cast House
//
//  Created by Simon Degn on 05/10/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    var playButton = UIButton()
    var ref: DatabaseReference!

    override func viewDidLoad() {
        ref = Database.database().reference()
       
        ref.child("status/NxiLSSnTtygXUzYfgbA5G0OmdOZ2/web").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print(postDict);
        })
        
        playButton.frame = CGRect(x: 0, y: 0, width: 300, height: 70)
        playButton.center = self.view.center
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = .blue
        playButton.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
        self.view.addSubview(playButton)
        
        ref.child("control/NxiLSSnTtygXUzYfgbA5G0OmdOZ2").observe(DataEventType.value, with: { (snapshot) in
            print("s")
            if let controlDict = snapshot.value as? [String : Any] {
               
                if ((controlDict["playing"]) as! Bool) {
                    self.playButton.setTitle("Pause", for: .normal)
                } else {
                    self.playButton.setTitle("Play", for: .normal)
                }
               
            } else {
                print("no control!! - no control! (1)")
            }

            
        })

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func playButtonClick() {
        
        ref.child("control/NxiLSSnTtygXUzYfgbA5G0OmdOZ2").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let controlDict = snapshot.value as? [String : Any] {

                let playing = ((controlDict["playing"]) as! Bool) ? false : true
                let device = (controlDict["device"])

                let control = ["playing": playing, "device": device]
                self.ref.child("control/NxiLSSnTtygXUzYfgbA5G0OmdOZ2").setValue(control)
                
            } else {
                print("no control!! - no control! (2)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

