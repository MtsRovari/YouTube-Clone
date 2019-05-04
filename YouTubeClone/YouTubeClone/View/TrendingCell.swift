//
//  TrendingCell.swift
//  YouTubeClone
//
//  Created by Mateus Rovari on 03/05/19.
//  Copyright © 2019 Mateus Rovari. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingFeed { (videos) in
            
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
