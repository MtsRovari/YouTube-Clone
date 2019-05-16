//
//  VideoLauncher.swift
//  YouTubeClone
//
//  Created by Mateus Rovari on 06/05/19.
//  Copyright © 2019 Mateus Rovari. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        var button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()
    
    var isPlaying = false
    
    @objc func handlePause() {
        
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
//        slider.setThumbImage(UIImage(named: ""), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        return slider
    }()
    
    @objc func handleSliderChange() {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(seconds: value, preferredTimescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                
                // perhaps do something later here
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        setupGradientLayer()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = UIColor.black
    }
    
    var player: AVPlayer?
    
    func setupPlayerView() {
        
        let urlString = "https://firebasestorage.googleapis.com/v0/b/social-media-dca30.appspot.com/o/y2mate.com%20-%20game_of_thrones_season_8_episode_5_preview_hbo_F1fqet9V494_1080p.mp4?alt=media&token=6bc68f78-ad3c-47e0-82f8-37db362aa63c"
        
        if let url = NSURL(string: urlString) {
            
            player = AVPlayer(url: url as URL)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //track player progress
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                
                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                
                self.currentTimeLabel.text = "\(minutesText):\(secondsString)"
                
                //move the slider thumb
                if let duration = self.player?.currentItem?.duration {
                    
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
            })
            
            player?.play()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
             
                let seconds = CMTimeGetSeconds(duration)
                
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.white
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            //16 x 9 is the aspect ratio of all HD videos
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                view.frame = keyWindow.frame
                
            }, completion: {(completedAnimation) in
                //maybe do something here later..
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        }
    }
}
