//
//  SubscriptionCell.swift
//  YouTubeClone
//
//  Created by Mateus Rovari on 03/05/19.
//  Copyright © 2019 Mateus Rovari. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubscriptionFeed { (videos) in
            
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
