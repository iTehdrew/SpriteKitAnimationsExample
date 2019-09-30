//
//  SKLabelNode+Emoji.swift
//  SpriteKitAnimationsExample
//
//  Created by Andrew Konovalskiy
//  Copyright © 2019 Andrew Konovalskiy. All rights reserved.
//

import Foundation
import SpriteKit

extension SKLabelNode {
    
    func renderEmoji(_ emoji: Character) {
        fontSize = 50
        text = String(emoji)
        
        // This enables us to move the label using its center point
        verticalAlignmentMode = .center
        horizontalAlignmentMode = .center
    }
}
