//
//  GameSettings.swift
//  breakoutIphone
//
//  Created by Masters3d on 7/4/14.
//  Copyright (c) 2014 Masters3d. All rights reserved.
//

import Foundation
import SpriteKit


extension SKEmitterNode {
    class func emitterNodeWithName(name: String) -> SKEmitterNode {
        guard let bundle = NSBundle.mainBundle().pathForResource(name, ofType: "sks") else {
            fatalError("Could not load bundle")
        }
        return NSKeyedUnarchiver.unarchiveObjectWithFile(bundle) as! SKEmitterNode
        
    }
}



