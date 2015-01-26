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


var tempBallPositions = [CGPoint.zeroPoint, CGPoint.zeroPoint]

//SK Type categories

let ballCategory    :UInt32 = 1
let brickCategory   :UInt32 = 2
let paddleCategory  :UInt32 = 4
let edgeCategory    :UInt32 = 0x1 << 3
let bottomEdgeCat   :UInt32 = 0x1 << 4
let waterCategory   :UInt32 = 0x1 << 5


let colorsArray = [
    SKColor.redColor(),
    SKColor.greenColor(),
    SKColor.blueColor(),
    SKColor.cyanColor(),
    SKColor.yellowColor(),
    SKColor.magentaColor(),
    SKColor.orangeColor(),
    SKColor.purpleColor(),
    SKColor.brownColor()]



// Scree size and bounds
let screenBounds = UIScreen.mainScreen().bounds
let screenScale = UIScreen.mainScreen().scale
let midleX = UIScreen.mainScreen().bounds.width


var holdPostion:CGPoint = CGPoint(x: midleX, y: 100)

var gameSettings:Dictionary = ["paddlePositionUpdate":CGPoint(x: midleX, y: 100)]


class GameScene: SKScene, SKPhysicsContactDelegate{

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.commonInit();
    }
    
    override init(size: CGSize) {
        super.init(size: size);
        self.commonInit();
    }
    
    func commonInit () -> () {
        
        println("commonInit")
        
        //Gravity tuned OFFs
        self.physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        
        //General Settings
        self.backgroundColor = SKColor.whiteColor()
        self.physicsWorld.contactDelegate = self
        
        
        // Rectangle around
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame )
        self.physicsBody!.categoryBitMask = edgeCategory
        
        
   
        println("commonInit Done")
    
    }
    

    
    override func didMoveToView(view: SKView) {
        

        //CenterPoint
        var centerPoint = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        //Set up my ball
        // circleof Radious not avalible in IOS7
        let myBallWidth:CGFloat = 20.0
        let myBall = SKShapeNode(circleOfRadius: myBallWidth )
        //let myBall = SKShapeNode()

        myBall.name = "myBallNode"
        self.addChild(myBall)
        //myBall.strokeColor = SKColor.redColor()
        myBall.lineWidth = 3
        
        myBall.position = centerPoint

        myBall.physicsBody = SKPhysicsBody(circleOfRadius: myBallWidth / 2.0)
        myBall.physicsBody!.restitution = 1 // 0-1
        myBall.physicsBody!.linearDamping = 0
        myBall.physicsBody!.friction = 0
        myBall.physicsBody!.categoryBitMask = ballCategory
        myBall.physicsBody!.contactTestBitMask = brickCategory | paddleCategory | bottomEdgeCat

        
        // Ball Dynamics
        var randomNegPos = CGFloat((arc4random()%2))
        var randomVector:CGFloat
        
        if randomNegPos == 0{
            randomVector = -8
        } else {
            randomVector = 8
        }
        
        let myBallVector = CGVectorMake(randomVector,8)
        myBall.physicsBody!.applyImpulse(myBallVector)
        //myBall.strokeColor = SKColor.blueColor()
        //myBall.glowWidth = 0.5
        
        
        var fireEmmiter = SKEmitterNode.emitterNodeWithName("myFireParticle")
        myBall.addChild(fireEmmiter)
        fireEmmiter.position = CGPoint(x: 0, y: 0)
        //fireEmmiter.particleRotation
        
        // Add Bottorm Line Colides
        
        

        var myBottomEdgeRec = CGRect(x: 0, y: 0, width: self.size.width, height: 4)
        // Rect Not avalible in IOS 7
        //var myBottomEdge = SKShapeNode(rect: myBottomEdgeRec )
        var myBottomEdge = SKShapeNode(rect: myBottomEdgeRec )
        self.addChild(myBottomEdge)
        myBottomEdge.strokeColor = SKColor.redColor()
        

        myBottomEdge.physicsBody = SKPhysicsBody(edgeLoopFromRect: myBottomEdgeRec)
        myBottomEdge.physicsBody!.categoryBitMask = bottomEdgeCat
        
        
        self.addPlayer(self.size)
        self.addBricks(LocX: 70,LocY: 780,howmany: 6)
        self.addBricks(LocX: 120,LocY: 760,howmany: 5)
        self.addBricks(LocX: 120,LocY: 740,howmany: 5)
        self.addBricks(LocX: 180,LocY: 720,howmany: 4)
        self.addBricks(LocX: 230,LocY: 700,howmany: 3)
        self.addBricks(LocX: 280,LocY: 680,howmany: 2)

        //self.addBricks()

        println("Ball and Edge addedd")

    }

    func addPlayer(Size:CGSize){
        
        let myFloorSize = CGSize(width: 150, height: 20)
        
        //Corner Radius does not work in IOs7
        var myFloor = SKShapeNode(rectOfSize: myFloorSize, cornerRadius: 9.9)
        //var myFloor = SKShapeNode(rectOfSize: myFloorSize)
        myFloor.name = "myFloorNode"
        self.addChild(myFloor)
        myFloor.strokeColor = SKColor.blackColor()
        myFloor.fillColor = SKColor.redColor()
        var myFloorLocation = CGPoint(x: size.width/2, y:100 )
        myFloor.position = myFloorLocation
        myFloor.physicsBody = SKPhysicsBody(rectangleOfSize: myFloorSize, center: self.frame.origin)
        myFloor.physicsBody!.affectedByGravity = false
        myFloor.physicsBody!.dynamic = false
        myFloor.physicsBody!.categoryBitMask = paddleCategory
        

        println("Paddle added")

        
        
       // for each:AnyObject in self.children{}
        
    }
    


    
    func addBricks(LocX:Int = 170, LocY:Int = 760, howmany:Int = 3){
        var index = 0
        var insertLocX = LocX
        var insertLocY = LocY
        var rangeInt = howmany-1
    
        
        for each in 0...rangeInt{
            let myBrickSize = CGSize(width: 99, height: 20)
            //courner radious doesnt work in IOS7
            //var myBrick = SKShapeNode(rectOfSize: myBrickSize, cornerRadius: 0)
            var myBrick = SKShapeNode(rectOfSize: myBrickSize)
            
            myBrick.name = "myBrickNode"
            self.addChild(myBrick)
           // myBrick.strokeColor = colorsArray[Int((arc4random()%UInt32(colorsArray.count)))]
            //TODO: Need to fix the color of the stroke

            myBrick.strokeColor = SKColor.blackColor()

            myBrick.fillColor = colorsArray[Int((arc4random()%UInt32(colorsArray.count)))]
            
            var myBrickLocation = CGPoint(x: insertLocX, y:insertLocY )
            myBrick.position = myBrickLocation
            myBrick.physicsBody = SKPhysicsBody(rectangleOfSize: myBrickSize, center: self.frame.origin)
            myBrick.physicsBody!.affectedByGravity = false
            myBrick.physicsBody!.dynamic = false
            myBrick.physicsBody!.categoryBitMask = brickCategory

            
            index += 1
            insertLocX += 100
            
        }
        println("bricks added")

    }


    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            let location :CGPoint? = touch.locationInNode(self) as CGPoint
            
            gameSettings["paddlePositionUpdate"] = CGPoint(x:midleX, y:100)
            
            if let loc = location {
                
        gameSettings["paddlePositionUpdate"] = CGPoint(x: loc.x, y: 100)
                }
            }
        
        println("touchesMoved Paddle movement function")

        }

    
    //func didBeginContact(){
    //println( "is this woring")
    
    func didBeginContact(contact : SKPhysicsContact){
        let soundPaddle : SKAction = SKAction.playSoundFileNamed("Drip.wav", waitForCompletion: false)
        let soundScrape : SKAction = SKAction.playSoundFileNamed("Scrape.wav", waitForCompletion: false)

        //Assuming the ball will alway hit stuff for BodyA will be what is hiting
        if contact.bodyA.categoryBitMask == brickCategory{
            contact.bodyA.node!.removeFromParent()
            println("BRICK A")
            self.runAction(soundScrape)}

        if contact.bodyA.categoryBitMask == paddleCategory{
            self.runAction(soundPaddle)
            println("Paddle!")
        }
        if contact.bodyA.categoryBitMask == bottomEdgeCat{
            println("bottomFloor")

   



            //contact.bodyB.node.position = CGPointMake(0, 0)
            //var NewBall = self.childNodeWithName("myBallNode")
            //var NewBall = contact.bodyB.node
            //NewBall.name = "myNewBallNode"
            //contact.bodyB.node.removeFromParent()
            //self.addChild(NewBall)
            
            //self.childNodeWithName("myNewBallNode").position = CGPointMake(midleX, 100)
            //var endScene = GameOver.sceneWithSize(self.size)
            var endScene = GameOver(size: self.size)

            var endTansition = SKTransition.doorsCloseHorizontalWithDuration(0.5)

            self.view!.presentScene(endScene, transition: endTansition)

        }

        println("did begin contact")

    
    }

    override func update(currentTime: CFTimeInterval) {
           //println(self.children)

        
       var paddlePosition = gameSettings["paddlePositionUpdate"]!
       var paddle = self.childNodeWithName("myFloorNode")
       var paddleRect = paddle!.calculateAccumulatedFrame()
       var paddleMidWidth:CGFloat = paddleRect.width/2
       var paddleRightPadding = self.size.width - paddleMidWidth
        

        if paddlePosition.x < paddleMidWidth {
            paddlePosition.x = paddleMidWidth
        }
        if paddlePosition.x > paddleRightPadding{
            paddlePosition.x = paddleRightPadding
        }
        
        
       self.childNodeWithName("myFloorNode")!.position = paddlePosition
        
        //My Ball Position
       tempBallPositions.append(self.childNodeWithName("myBallNode")!.position)
        
        var fireBallEmitter = self.childNodeWithName("myBallNode")!.children[0] as SKEmitterNode
        // Do angle cal
        
        
        var xDiff = (tempBallPositions[0].x - tempBallPositions[1].x)
        var yDiff = (tempBallPositions[0].y - tempBallPositions[1].y)
        
        
        var xyDiff = atan2(yDiff, xDiff)
        
        var radiantAngle = xyDiff - 2.0
        //var radiantAngle = CGFloat(2.0)
        
        //var angleDegree = (Double(radiantAngle) / (2.0 * Double(M_PI))) * 360.0
        fireBallEmitter.zRotation = radiantAngle
        //fireBallEmitter.emissionAngle = CGFloat(angleDegree)
            
        
       // SKAction.sequence(<#actions: AnyObject[]?#>)
       // SKAction.group(<#actions: AnyObject[]?#>)
        
        
        
            
        tempBallPositions.removeAtIndex(0)
        
    
        
        //println(angleDegree)
        //println(tempBallPositions)
       
        
        /* Called before each frame is rendered */
    }
}