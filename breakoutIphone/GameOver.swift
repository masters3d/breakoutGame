//
//  GameOver.swift
//  breakoutIphone
//
//  Created by Masters3d on 7/6/14.
//  Copyright (c) 2014 Masters3d. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(" Game Over initianaled")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        //Sound
        let soundChom : SKAction = SKAction.playSoundFileNamed("Chomp.wav", waitForCompletion: true)
        run(soundChom)
        //Background
        backgroundColor = SKColor.lightGray
        //Label One
        let label = SKLabelNode(fontNamed:"Futura Medium")
        label.text = "GAME OVER"
        label.fontColor = SKColor.black
        label.fontSize = 44
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(label)
        
        //Label TryAgain
        
        let labelTryAgain = SKLabelNode(fontNamed:"Futura Medium")
        labelTryAgain.text = "Try Again?"
        labelTryAgain.fontColor = SKColor.black
        labelTryAgain.fontSize = 44
        labelTryAgain.position = CGPoint(x: label.position.x, y: -50)
        let moveTryAgainLabel = SKAction.moveTo(y: label.position.y - 80, duration: 0.5)
        labelTryAgain.run(moveTryAgainLabel)
        addChild(labelTryAgain)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let soundStar : SKAction = SKAction.playSoundFileNamed("star.caf", waitForCompletion: true)
        run(soundStar)
        
       //var firstScene = GameScene.sceneWithSize(size)
        let firstScene = GameScene(size: size)
        let startTansition = SKTransition.doorsOpenVertical(withDuration: 0.6)
        view?.presentScene(firstScene, transition: startTansition)
    }

}
