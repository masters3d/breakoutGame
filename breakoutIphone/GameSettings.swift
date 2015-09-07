//
//  GameSettings.swift
//  breakoutIphone
//
//  Created by Masters3d on 7/4/14.
//  Copyright (c) 2014 Masters3d. All rights reserved.
//

import UIKit
import SpriteKit




extension SKEmitterNode {
    class func emitterNodeWithName(name: String) -> SKEmitterNode {
        guard let bundle = NSBundle.mainBundle().pathForResource(name, ofType: "sks") else {
            fatalError("Could not load bundle")
        }
        return NSKeyedUnarchiver.unarchiveObjectWithFile(bundle) as! SKEmitterNode
        
    }
}


extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        guard let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") else {
            fatalError("Could not load bundle") }
        
        guard let sceneData = try? NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe) else {
            fatalError("Could not load bundle")
        }
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}


