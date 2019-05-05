//
//  Video.swift
//  YouTubeClone
//
//  Created by Mateus Rovari on 21/04/19.
//  Copyright © 2019 Mateus Rovari. All rights reserved.
//

import UIKit

struct Video: Decodable {
    
    let title: String?
    let number_of_views: Int?
    let thumbnail_image_name: String?
    let channel: Channel?
    let duration: Int?
    //    let uploadDate: NSDate?
    
}

struct Channel: Decodable {
    let name: String?
    let profile_image_name: String?
    
}
