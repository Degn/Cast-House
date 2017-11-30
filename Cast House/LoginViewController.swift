//
//  LoginViewController.swift
//  Cast House
//
//  Created by Simon Degn on 15/10/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController, CAAnimationDelegate {

    var root: RootViewController?

    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 203/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    var logoIcon = UIView()
    var logoOuterCircle = UIView()
    var logoInnerCircle = UIView()
    var logoLabelUpper = UILabel()
    var logoLabelLower = UILabel()
    
    var loginButton = UIButton()
    var loginButtonDescription = UILabel()
    
    var lightBoxView = LightBoxViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .white
        
        logoIcon.frame = CGRect(x: 0, y: 0, width: 214, height: 100)
        logoIcon.center = CGPoint(x:  self.view.center.x*3, y:  140)
        logoIcon.alpha = 0
        self.view.addSubview(logoIcon)
        
        logoOuterCircle.frame = CGRect(x: 16, y: 16, width: 76, height: 76)
        logoOuterCircle.layer.cornerRadius = 38
        logoOuterCircle.clipsToBounds = true
        logoOuterCircle.backgroundColor = .white
        logoOuterCircle.center = self.view.center
        self.view.addSubview(logoOuterCircle)
        
        logoInnerCircle.frame = CGRect(x: 30, y: 30, width: 48, height: 48)
        logoInnerCircle.layer.cornerRadius = 24
        logoInnerCircle.clipsToBounds = true
        logoInnerCircle.backgroundColor = .white
        logoInnerCircle.layer.zPosition = 100
        logoInnerCircle.layer.masksToBounds = false
        logoInnerCircle.layer.shadowColor = UIColor.black.cgColor
        logoInnerCircle.layer.shadowOpacity = 0.4
        logoInnerCircle.layer.shadowOffset = CGSize(width: 4, height: 4)
        logoInnerCircle.layer.shadowRadius = 10
        logoInnerCircle.center = self.view.center
        self.view.addSubview(logoInnerCircle)
        
        logoLabelUpper.frame = CGRect(x: 102, y: 13, width: 140, height: 48)
        logoLabelUpper.text = "CAST"
        logoLabelUpper.font = UIFont(name: "AsapCondensed-Medium", size: 35)
        logoLabelUpper.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0)
        logoIcon.addSubview(logoLabelUpper)
        
        logoLabelLower.frame = CGRect(x: 102, y: 46, width: 140, height: 48)
        logoLabelLower.text = "HOUSE"
        logoLabelLower.font = UIFont(name: "AsapCondensed-Medium", size: 35)
        logoLabelLower.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0)
        logoIcon.addSubview(logoLabelLower)
        
        loginButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width-80, height: 50)
        loginButton.layer.borderColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0).cgColor
        loginButton.layer.borderWidth = 1.0
        loginButton.setTitle("Continue with Facebook", for: .normal)
        loginButton.setTitleColor(UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0), for: .normal)
        loginButton.titleLabel!.font = UIFont(name: "AsapCondensed-Medium", size: 18)
        loginButton.center = CGPoint(x:  self.view.center.x, y:  self.view.frame.size.height + 100)
        loginButton.backgroundColor = .clear
        loginButton.alpha = 0
        loginButton.backgroundColor = .clear
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        loginButtonDescription.frame = CGRect(x: 0, y: 0, width: 220, height: 40)
        loginButtonDescription.font = UIFont(name: "AsapCondensed-Medium", size: 12)
        loginButtonDescription.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0)
        loginButtonDescription.center = CGPoint(x:  self.view.center.x, y:  self.view.frame.size.height + 50)
        loginButtonDescription.text = "By signing up you agree to our Terms & Conditions and our Privacy Policy."
        loginButtonDescription.numberOfLines = 2
        loginButtonDescription.textAlignment = .center
        loginButtonDescription.alpha = 0
        self.view.addSubview(loginButtonDescription)

        lightBoxView.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width-80, height: 150)
        lightBoxView.view.center = CGPoint(x:  self.view.center.x, y: self.view.frame.size.height + 60)
        lightBoxView.addLabel(textLines: ["JOIN TODAY", "& BE A PART", "OF THE STORY"])
        lightBoxView.view.layer.borderWidth = 0.0
        lightBoxView.view.layer.borderColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0).cgColor
        lightBoxView.view.alpha = 0
        lightBoxView.view.layer.shadowColor = UIColor.white.cgColor
        lightBoxView.view.layer.shadowOpacity = 0.5
        lightBoxView.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        lightBoxView.view.layer.shadowRadius = 50

        self.view.addSubview(lightBoxView.view)
        
        flyIn()
    }

    func flyIn() {
        UIView.animate(withDuration: 0.6, animations: {
            self.view.backgroundColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
            self.logoInnerCircle.backgroundColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.8, options: .curveEaseInOut, animations: {
            self.logoOuterCircle.center = CGPoint(x:  self.view.center.x - 53, y:  144)
            self.logoInnerCircle.center = CGPoint(x:  self.view.center.x - 53, y:  144)
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0.8, options: .curveEaseInOut, animations: {
            self.logoIcon.center = CGPoint(x:  self.view.center.x, y:  140)
            self.logoIcon.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 1.1, options: .curveEaseOut, animations: {
            self.lightBoxView.view.center = CGPoint(x:  self.view.center.x, y:  (self.view.center.y+40))
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 1.7, options: .curveEaseOut, animations: {
            self.lightBoxView.view.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 1.9, options: .curveEaseOut, animations: {
            self.loginButton.center = CGPoint(x:  self.view.center.x, y:  self.view.frame.size.height - 100)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 1.9, options: .curveEaseOut, animations: {
            self.loginButton.center = CGPoint(x:  self.view.center.x, y:  self.view.frame.size.height - 100)
            self.loginButton.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 2.1, options: .curveEaseOut, animations: {
            self.loginButtonDescription.center = CGPoint(x:  self.view.center.x, y:  self.view.frame.size.height - 50)
            self.loginButtonDescription.alpha = 1.0
        }, completion: nil)
        
        let animation = CABasicAnimation(keyPath: "shadowRadius")
        animation.fromValue = 50
        animation.toValue = 38
        animation.repeatCount = 1000
        animation.duration = 1.8
        animation.autoreverses = true
        self.lightBoxView.view.layer.add(animation, forKey: "cornerRadius")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        gradient.frame = logoOuterCircle.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        logoOuterCircle.layer.addSublayer(gradient)
        gradient.zPosition = 0

        animateGradient()
        
    }
    
    func animateGradient() {
        
        currentGradient += 1
       
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 4.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        if flag {
            gradient.colors = gradientSet[currentGradient]
            gradientSet.append([randColor().cgColor, randColor().cgColor])
            animateGradient()
        }
    }
    
    func randColor() -> UIColor {
        let color = UIColor(red: (CGFloat(arc4random_uniform(255))/255.0), green: (CGFloat(arc4random_uniform(255))/255.0), blue: (CGFloat(arc4random_uniform(255))/255.0), alpha: 1)
        return color
    }
    
    
    @objc func loginButtonClick()  {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
                    Auth.auth().signIn(with: credential) { (user, error) in
                        if error != nil {
                            return
                        }
                    }
                    
                    self.root!.loggedIn()
                }
            }
        }
    }
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result)
                }
            })
        }
    }
}

