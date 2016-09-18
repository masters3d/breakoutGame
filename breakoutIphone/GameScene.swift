//
//  GameScene.swift
//  breakoutIphone
//
//  Created by Masters3d on 7/3/14.
//  Copyright (c) 2014 Masters3d. All rights reserved.
//

import SpriteKit
import Foundation
import Swift
import Darwin


var tempBallPositions = [CGPoint.zero, CGPoint.zero]

//SK Type categories

let ballCategory    :UInt32 = 1
let brickCategory   :UInt32 = 2
let paddleCategory  :UInt32 = 4
let edgeCategory    :UInt32 = 0x1 << 3
let bottomEdgeCat   :UInt32 = 0x1 << 4
let waterCategory   :UInt32 = 0x1 << 5


let colorsArray = [
    SKColor.red,
    SKColor.green,
    SKColor.blue,
    SKColor.cyan,
    SKColor.yellow,
    SKColor.magenta,
    SKColor.orange,
    SKColor.purple,
    SKColor.brown]

// Scree size and bounds
let screenBounds = UIScreen.main.bounds
let screenScale = UIScreen.main.scale
let midleX = UIScreen.main.bounds.width

var holdPostion:CGPoint = CGPoint(x: midleX, y: 100)

var gameSettings:Dictionary = ["paddlePositionUpdate":CGPoint(x: midleX, y: 100)]

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit();
    }
    
    override init(size: CGSize) {
        super.init(size: size);
        commonInit();
    }
    
    func commonInit() {
        
        print("commonInit")
        
        //Gravity tuned OFFs
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        
        //General Settings
        backgroundColor = SKColor.white
        physicsWorld.contactDelegate = self
        
        
        // Rectangle around
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame )
        physicsBody?.categoryBitMask = edgeCategory
        
        print("commonInit Done")
        
    }
    
    
    override func didMove(to view: SKView) {
        //CenterPoint
        let centerPoint = CGPoint(x:frame.midX, y:frame.midY)
        
        //Set up my ball
        // circleof Radious not avalible in IOS7
        let myBallWidth:CGFloat = 20.0
        let myBall = SKShapeNode(circleOfRadius: myBallWidth )
        //let myBall = SKShapeNode()
        
        myBall.name = "myBallNode"
        addChild(myBall)
        //myBall.strokeColor = SKColor.redColor()
        myBall.lineWidth = 3
        
        myBall.position = centerPoint
        myBall.physicsBody = SKPhysicsBody(circleOfRadius: myBallWidth / 2.0)
        myBall.physicsBody?.restitution = 1 // 0-1
        myBall.physicsBody?.linearDamping = 0
        myBall.physicsBody?.friction = 0
        myBall.physicsBody?.categoryBitMask = ballCategory
        myBall.physicsBody?.contactTestBitMask = brickCategory | paddleCategory | bottomEdgeCat
        // Ball Dynamics
        let randomNegPos = CGFloat(arc4random()%2)
        var randomVector:CGFloat
        
        if randomNegPos == 0{
            randomVector = -8
        } else {
            randomVector = 8
        }
        
        let myBallVector = CGVector(dx: randomVector,dy: 8)
        myBall.physicsBody?.applyImpulse(myBallVector)
        //myBall.strokeColor = SKColor.blueColor()
        //myBall.glowWidth = 0.5
        
        
        let fireEmmiter = SKEmitterNode.emitterNodeWithName("myFireParticle")
        myBall.addChild(fireEmmiter)
        fireEmmiter.position = CGPoint(x: 0, y: 0)
        //fireEmmiter.particleRotation
        
        // Add Bottorm Line Colides
        
        
        let myBottomEdgeRec = CGRect(x: 0, y: 0, width: size.width, height: 4)
        // Rect Not avalible in IOS 7
        //var myBottomEdge = SKShapeNode(rect: myBottomEdgeRec )
        let myBottomEdge = SKShapeNode(rect: myBottomEdgeRec )
        addChild(myBottomEdge)
        myBottomEdge.strokeColor = SKColor.red
        
        
        myBottomEdge.physicsBody = SKPhysicsBody(edgeLoopFrom: myBottomEdgeRec)
        myBottomEdge.physicsBody?.categoryBitMask = bottomEdgeCat
        
        
        addPlayer(size)
        addBricks(locX: 70, locY: 780, quantity: 6)
        addBricks(locX: 120,locY: 760, quantity: 5)
        addBricks(locX: 120,locY: 740, quantity: 5)
        addBricks(locX: 180,locY: 720, quantity: 4)
        addBricks(locX: 230,locY: 700, quantity: 3)
        addBricks(locX: 280,locY: 680, quantity: 2)
        
        //addBricks()
        
        print("Ball and Edge addedd")
        
    }
    
    func addPlayer(_ Size:CGSize){
        
        let myFloorSize = CGSize(width: 150, height: 20)
        
        //Corner Radius does not work in IOs7
        let myFloor = SKShapeNode(rectOf: myFloorSize, cornerRadius: 9.9)
        //var myFloor = SKShapeNode(rectOfSize: myFloorSize)
        myFloor.name = "myFloorNode"
        addChild(myFloor)
        myFloor.strokeColor = SKColor.black
        myFloor.fillColor = SKColor.red
        let myFloorLocation = CGPoint(x: size.width/2, y:100 )
        myFloor.position = myFloorLocation
        myFloor.physicsBody = SKPhysicsBody(rectangleOf: myFloorSize, center: frame.origin)
        myFloor.physicsBody?.affectedByGravity = false
        myFloor.physicsBody?.isDynamic = false
        myFloor.physicsBody?.categoryBitMask = paddleCategory
        print("Paddle added")
    }
    
    
    
    
    func addBricks(locX:Int = 170, locY:Int = 760, quantity:Int = 3){
        var index = 0
        var insertLocX = locX
        let insertLocY = locY
        let rangeInt = quantity - 1
        
        for _ in 0...rangeInt{
            let myBrickSize = CGSize(width: 99, height: 20)
            //courner radious doesnt work in IOS7
            //var myBrick = SKShapeNode(rectOfSize: myBrickSize, cornerRadius: 0)
            let myBrick = SKShapeNode(rectOf: myBrickSize)
            
            myBrick.name = "myBrickNode"
            addChild(myBrick)
            // myBrick.strokeColor = colorsArray[Int((arc4random()%UInt32(colorsArray.count)))]
            //TODO: Need to fix the color of the stroke
            
            myBrick.strokeColor = SKColor.black
            
            myBrick.fillColor = colorsArray[Int((arc4random()%UInt32(colorsArray.count)))]
            
            let myBrickLocation = CGPoint(x: insertLocX, y:insertLocY )
            myBrick.position = myBrickLocation
            myBrick.physicsBody = SKPhysicsBody(rectangleOf: myBrickSize, center: frame.origin)
            myBrick.physicsBody?.affectedByGravity = false
            myBrick.physicsBody?.isDynamic = false
            myBrick.physicsBody?.categoryBitMask = brickCategory
            
            index += 1
            insertLocX += 100
            
        }
        print("bricks added")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /* Called when a touch begins */
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            // Moves the paddle to the middle of the screen
            gameSettings["paddlePositionUpdate"] = CGPoint(x:midleX, y:100)
            
            //Update the paddle to the x movement of the finger
            gameSettings["paddlePositionUpdate"] = CGPoint(x: location.x, y: 100)
        }
        print("touchesMoved Paddle movement function")
    }
    
    func didBegin(_ contact : SKPhysicsContact){
        let soundPaddle = SKAction.playSoundFileNamed("Drip.wav", waitForCompletion: false)
        let soundScrape = SKAction.playSoundFileNamed("Scrape.wav", waitForCompletion: false)
        
        //Assuming the ball will always hit stuff for BodyA will be what is hiting
        if contact.bodyA.categoryBitMask == brickCategory{
            contact.bodyA.node?.removeFromParent()
            print("BRICK A")
            run(soundScrape)}
        
        if contact.bodyA.categoryBitMask == paddleCategory{
            run(soundPaddle)
            print("Paddle")
        }
        if contact.bodyA.categoryBitMask == bottomEdgeCat{
            print("bottomFloor")

            let endScene = GameOver(size: size)
            
            let endTansition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
            
            view?.presentScene(endScene, transition: endTansition)
            
        }
        print("did begin contact")
    }
    
    override func update(_ currentTime: TimeInterval) {
        var paddlePosition = gameSettings["paddlePositionUpdate"] ?? CGPoint()
        let paddle = childNode(withName: "myFloorNode")
        let paddleRect = paddle?.calculateAccumulatedFrame()
        let paddleWidth = paddleRect?.width ?? CGFloat(0)
        let paddleMidWidth = paddleWidth / 2
        let paddleRightPadding = size.width - paddleMidWidth
        
        if paddlePosition.x < paddleMidWidth {
            paddlePosition.x = paddleMidWidth
        }
        if paddlePosition.x > paddleRightPadding{
            paddlePosition.x = paddleRightPadding
        }
        
        childNode(withName: "myFloorNode")?.position = paddlePosition
        
        //My Ball Position
        tempBallPositions.append((childNode(withName: "myBallNode")?.position) ?? CGPoint())
        
        let fireBallEmitter = childNode(withName: "myBallNode")?.children[0] as! SKEmitterNode
        // Do angle cal
        
        
        let xDiff = (tempBallPositions[0].x - tempBallPositions[1].x)
        let yDiff = (tempBallPositions[0].y - tempBallPositions[1].y)
        
        let xyDiff = atan2(yDiff, xDiff)
        
        let radiantAngle = xyDiff - 2.0
        //var radiantAngle = CGFloat(2.0)
        
        //var angleDegree = (Double(radiantAngle) / (2.0 * Double(M_PI))) * 360.0
        fireBallEmitter.zRotation = radiantAngle
        //fireBallEmitter.emissionAngle = CGFloat(angleDegree)
        
        tempBallPositions.remove(at: 0)
        
        /* Called before each frame is rendered */
    }
}
