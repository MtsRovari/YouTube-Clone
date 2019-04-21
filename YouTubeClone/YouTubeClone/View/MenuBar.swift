//
//  MenuBar.swift
//  YouTubeClone
//
//  Created by Mateus Rovari on 20/04/19.
//  Copyright © 2019 Mateus Rovari. All rights reserved.
//

import UIKit

class MenuBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
    } 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
