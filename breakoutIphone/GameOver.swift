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
        runAction(soundChom)
        //Background
        backgroundColor = SKColor.lightGrayColor()
        //Label One
        let label = SKLabelNode(fontNamed:"Futura Medium")
        label.text = "GAME OVER"
        label.fontColor = SKColor.blackColor()
        label.fontSize = 44
        label.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        addChild(label)
        
        
        
        
        
        //Label TryAgain
        
        
        let labelTryAgain = SKLabelNode(fontNamed:"Futura Medium")
        labelTryAgain.text = "Try Again?"
        labelTryAgain.fontColor = SKColor.blackColor()
        labelTryAgain.fontSize = 44
        labelTryAgain.position = CGPoint(x: label.position.x, y: -50)
        let moveTryAgainLabel = SKAction.moveToY(label.position.y - 80, duration: 0.5)
        labelTryAgain.runAction(moveTryAgainLabel)
        addChild(labelTryAgain)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(" Game Over initianaled")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        let soundStar : SKAction = SKAction.playSoundFileNamed("star.caf", waitForCompletion: true)
        runAction(soundStar)
        
       //var firstScene = GameScene.sceneWithSize(size)
        let firstScene = GameScene(size: size)
        let startTansition = SKTransition.doorsOpenVerticalWithDuration(0.6)
        view?.presentScene(firstScene, transition: startTansition)
        
        
    
    
    }




}
