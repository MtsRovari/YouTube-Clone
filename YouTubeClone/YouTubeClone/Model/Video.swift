//
//  Video.swift
//  YouTubeClone
//
//  Created by Mateus Rovari on 21/04/19.
//  Copyright © 2019 Mateus Rovari. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadData: NSDate?
    
    var channel: Channel?
}

class Channel: NSObject {
    var name: String?
    var profileImageName: String?
}
