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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        
        let urlString = "https://firebasestorage.googleapis.com/v0/b/social-media-dca30.appspot.com/o/y2mate.com%20-%20game_of_thrones_season_8_episode_5_preview_hbo_F1fqet9V494_1080p.mp4?alt=media&token=6bc68f78-ad3c-47e0-82f8-37db362aa63c"
        
        if let url = NSURL(string: urlString) {
          
            let player = AVPlayer(url: url as URL)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player.play()
        }
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
