//
//  PlayerViewController.swift
//  Cast House
//
//  Created by Simon Degn on 22/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import MediaPlayer

class PlayerView: UIView, AVAudioPlayerDelegate {

    var root: RootViewController?
    var playerEpisodeObject: EpisodeObject?
    var playButton = UIButton()
    var pauseButton = UIButton()
    var openButton = UIButton()
    var titleLabel = UILabel()
    var publisherLabel = UILabel()
    var episodeImageView = UIImageView()
    var timeSlider = UISlider()
    var audioPlayer = AVPlayer()
    let audioSession = AVAudioSession()

    func setPlayer() {
        
        // general
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.init(red: (240/255.0), green: (240/255.0), blue: (240/255.0), alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
        
        // Play button
        playButton.frame = CGRect(x: 10, y: 10, width: 35, height: 35)
        playButton.setImage(#imageLiteral(resourceName: "button_play"), for: .normal)
        playButton.imageEdgeInsets = UIEdgeInsetsMake(7, 5, 7, 5)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        self.addSubview(playButton)
        
        // Pause button
        pauseButton.frame = CGRect(x: 10, y: 10, width: 35, height: 35)
        pauseButton.setImage(#imageLiteral(resourceName: "button_pause"), for: .normal)
        pauseButton.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
        pauseButton.alpha = 0.0
        pauseButton.isUserInteractionEnabled = false
        pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
        self.addSubview(pauseButton)
        
        // Title label
        titleLabel.frame = CGRect(x: 55.0, y: 10.0, width: self.frame.size.width-110.0, height: 35.0)
        titleLabel.text = ""
        titleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 15.0)
        titleLabel.textColor = UIColor.init(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1.0)
        self.addSubview(titleLabel)
        
        // Publisher label
        publisherLabel.frame = CGRect.zero
        publisherLabel.text = ""
        publisherLabel.font = UIFont(name: "AsapCondensed-Medium", size: 15.0)
        publisherLabel.textColor = UIColor.init(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1.0)
        publisherLabel.textAlignment = .center
        self.addSubview(publisherLabel)
        
        // Image view
        episodeImageView.frame = CGRect(x: self.frame.size.width - 43.0, y: 10, width: 35, height: 35)
        episodeImageView.backgroundColor = .lightGray
        episodeImageView.layer.cornerRadius = 6.0
        episodeImageView.clipsToBounds = true
        self.addSubview(episodeImageView)
        
        // Time slider
        timeSlider.frame = CGRect(x: 16.0, y: self.frame.size.height + 50, width: self.frame.size.width-32.0, height: 4)
        timeSlider.tintColor = UIColor.brown
        self.addSubview(timeSlider)
        
        // Open detail button
        openButton.frame = CGRect(x: 55.0, y: 10.0, width: self.frame.size.width - 55.0, height: 35.0)
        openButton.alpha = 0.4
        openButton.isUserInteractionEnabled = true
        openButton.addTarget(self, action: #selector(openEpisodeDetailView), for: .touchUpInside)
        self.addSubview(openButton)
        
        // Background stuff
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    func updateEpisodeInfo(episodeObject: EpisodeObject) {
        
        playerEpisodeObject = episodeObject
        
        let image:UIImage = episodeObject.image
        let title = episodeObject.title
        let publisher = episodeObject.author
        
        titleLabel.text = title
        publisherLabel.text = publisher
        episodeImageView.image = image
        
        let url = episodeObject.link
        let fileURL: URL = URL(fileURLWithPath: url)
        
        self.audioPlayer = AVPlayer.init(url: fileURL as URL)
        audioPlayer.volume = 1.0
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [String: AnyObject]()

        let albumArt = MPMediaItemArtwork(boundsSize:CGSize(width: 400, height: 400)) { sz in
            return image
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [String: AnyObject]()
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: publisher,
            MPMediaItemPropertyPlaybackDuration: 3233,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: 443,
            MPMediaItemPropertyArtwork: albumArt
        ]
        
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            //Update your button here for the pause command
            self.pause()
            return .success
        }
        
        MPRemoteCommandCenter.shared().playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            //Update your button here for the play command
            self.play()
            return .success
        }
    }
    
    
    @objc func openEpisodeDetailView() {
        root!.openPlayerDetail(episodeObject: playerEpisodeObject!)
        self.openButton.isUserInteractionEnabled = false
        self.publisherLabel.frame = CGRect(x: 16.0, y: -30.0, width: self.frame.size.width-32.0, height: 30)

        UIView.animate(withDuration: 0.18) {
            self.episodeImageView.frame = CGRect(x: self.frame.size.width / 2 - 50, y: 20, width: 100, height: 100)

            self.titleLabel.frame = CGRect(x: 16.0, y: 128.0, width: self.frame.size.width-32.0, height: 30)
            self.titleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 18.0)
            self.titleLabel.textAlignment = .center
            self.publisherLabel.frame = CGRect(x: 16.0, y: 148.0, width: self.frame.size.width-32.0, height: 30)
            
            self.playButton.frame = CGRect(x: self.frame.width / 2 - 35, y: 180.0, width: 70, height: 70)
            self.pauseButton.frame = CGRect(x: self.frame.width / 2 - 35, y: 180.0, width: 70, height: 70)
            self.playButton.imageEdgeInsets = UIEdgeInsetsMake(14, 10, 14, 10)
            self.pauseButton.imageEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14)
            
            self.timeSlider.frame = CGRect(x: 16.0, y: 270.0, width: self.frame.size.width - 32.0, height: 3.0)
        }
    }
    
    
    @objc func closeEpisodeDetailView() {
        self.openButton.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.18) {
            self.episodeImageView.frame = CGRect(x: self.frame.size.width - 43.0, y: 10, width: 35, height: 35)

            self.titleLabel.frame = CGRect(x: 55.0, y: 10.0, width: self.frame.size.width-110.0, height: 35.0)
            self.titleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 15.0)
            self.titleLabel.textAlignment = .left
            self.publisherLabel.frame = CGRect(x: 16.0, y: -30.0, width: self.frame.size.width-32.0, height: 30)

            self.playButton.frame = CGRect(x: 10, y: 10, width: 35, height: 35)
            self.pauseButton.frame = CGRect(x: 10, y: 10, width: 35, height: 35)
            self.playButton.imageEdgeInsets = UIEdgeInsetsMake(7, 5, 7, 5)
            self.pauseButton.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
        }
    }
    
    
    func openPlaylist() {
        
    }
    
    
    @objc func play() {
        audioPlayer.play()

        playButton.isUserInteractionEnabled = false
        pauseButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.1) {
            self.playButton.alpha = 0.0
            self.pauseButton.alpha = 1.0
        }
        
    }
    
    
    @objc func pause() {
        audioPlayer.pause()

        playButton.isUserInteractionEnabled = true
        pauseButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.1) {
            self.playButton.alpha = 1.0
            self.pauseButton.alpha = 0.0
        }
    }
    
    func listenVolumeButton() {
        do {
            try audioSession.setActive(true)
        } catch {
            print("some error")
        }
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            print("got in here")
        }
    }
}

