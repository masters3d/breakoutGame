//
//  GameOver.swift
//  breakoutIphone
//
//  Created by Masters3d on 7/6/14.
//  Copyright (c) 2014 Masters3d. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    

    override init(size: CGSize) {
        super.init(size: size)
        //Sound
        let soundChom : SKAction = SKAction.playSoundFileNamed("Chomp.wav", waitForCompletion: true)
        self.runAction(soundChom)
        //Background
        self.backgroundColor = SKColor.lightGrayColor()
        //Label One
        var label = SKLabelNode(fontNamed:"Futura Medium")
        label.text = "GAME OVER"
        label.fontColor = SKColor.blackColor()
        label.fontSize = 44
        label.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(label)
        
        
        
        
        
        //Label TryAgain
        
        
        var labelTryAgain = SKLabelNode(fontNamed:"Futura Medium")
        labelTryAgain.text = "Try Again?"
        labelTryAgain.fontColor = SKColor.blackColor()
        labelTryAgain.fontSize = 44
        labelTryAgain.position = CGPoint(x: label.position.x, y: -50)
        var moveTryAgainLabel = SKAction.moveToY(label.position.y - 80, duration: 0.5)
        labelTryAgain.runAction(moveTryAgainLabel)
        self.addChild(labelTryAgain)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println(" Game Over initianaled")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
    
        let soundStar : SKAction = SKAction.playSoundFileNamed("star.caf", waitForCompletion: true)
        self.runAction(soundStar)
        
       //var firstScene = GameScene.sceneWithSize(self.size)
        var firstScene = GameScene(size: self.size)
        var startTansition = SKTransition.doorsOpenVerticalWithDuration(0.6)
        self.view!.presentScene(firstScene, transition: startTansition)
        
        
    
    
    }




}
