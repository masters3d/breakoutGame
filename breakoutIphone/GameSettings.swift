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
    class func emitterNodeWithName(_ name: String) -> SKEmitterNode {
        guard let bundle = Bundle.main.path(forResource: name, ofType: "sks") else {
            fatalError("Could not load bundle")
        }
        return NSKeyedUnarchiver.unarchiveObject(withFile: bundle) as! SKEmitterNode
    }
}


extension SKNode {
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        guard let path = Bundle.main.path(forResource: file as String, ofType: "sks") else {
            fatalError("Could not load bundle") }
        
        guard let sceneData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped) else {
            fatalError("Could not load bundle")
        }
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
        archiver.setClass(classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}


