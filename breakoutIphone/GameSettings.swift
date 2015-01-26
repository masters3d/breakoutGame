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
        return NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource(name, ofType: "sks")!) as SKEmitterNode
    }
}



