//
//  PhysicsScene.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 9/28/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation
class PhysicsScene : CCScene, CCPhysicsCollisionDelegate {
    
    let kBackgroundZ = 10
    let kGroundZ = 15
    let kObjectsZ = 20
    
    
    private var _physicsNode:CCPhysicsNode? = nil
    private var _batchNodeMain:CCSpriteBatchNode? = nil
    
    private var _childPhyNode:CCNode? = nil
    
    private var _ground:CCSprite? = nil
    
    private var _hunter:PhysicsHunter? = nil
    
    private var _stoneGroundCollisionGroup:NSObject? = nil
    
    private var _timeUntilNextStone:Float? = nil
    
    private var _stones:[CCSprite]? = nil
    
    private var _batchNodeBirds:CCSpriteBatchNode? = nil
    
    
    func createPhysicsNode() {
        //1: Creating physics node, a parent node to all nodes with physics bodies
        _physicsNode = CCPhysicsNode() as? CCPhysicsNode
        
        //2: Setting gravity
        _physicsNode?.gravity = ccp(0, -250)
        
        _physicsNode?.collisionDelegate = self
        
        //3: This will cause physics node to draw physics shapes, colisions and so on
        _physicsNode?.debugDraw = true
        
        //4: Adding it to the scene.  All other objects, including batch nodes will be added to it.
        self.addChild(_physicsNode)
    }
    
    func createBatchNodes() {
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("physics_level.plist")
        _batchNodeMain = CCSpriteBatchNode(file: "physics_level.png")
        _physicsNode?.addChild(_batchNodeMain)
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("Cocohunt.plist")
        _batchNodeBirds = CCSpriteBatchNode(file: "Cocohunt.png")
        _physicsNode?.addChild(_batchNodeBirds)
        //_childPhyNode = CCNode()
        //_physicsNode?.addChild(_childPhyNode)
        
    }
    
    func createHunter() {
        _hunter = PhysicsHunter()
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        _hunter!.anchorPoint = ccp(0.5, 0)
        //_hunter!.position = ccp(viewSize.width * 05, (_ground?.contentSizeInPoints.height)! + 10)
        
        _batchNodeMain!.addChild(_hunter, z: kObjectsZ)
        _hunter!.position = ccp(viewSize.width * 0.5, (_ground?.contentSizeInPoints.height)! + 10)
        self.userInteractionEnabled = true
    }
    
    func addBackground() {
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        let bg:CCSprite = CCSprite.spriteWithImageNamed("physics_level_bg.png") as! CCSprite
        bg.position = ccp(viewSize.width * 0.5, viewSize.height * 0.5)
        _batchNodeMain!.addChild(bg, z: kBackgroundZ)
    }
    
    func addGround() {
        //1: Creating a sprite
        _ground = CCSprite(imageNamed: "ground.png")
        
        //2: Creating rectangle equal to the ground sprite
        let groundRect:CGRect = CGRect(origin: CGPoint.zero, size: _ground!.contentSize)
        
        //3: Creating physics body using the rectanble above
        let groundBody:CCPhysicsBody = CCPhysicsBody(rect: groundRect, cornerRadius: 0)
        
        groundBody.collisionType = "ground"
        //groundBody.collisionCategories = ["obstacles"]
        groundBody.collisionGroup = _stoneGroundCollisionGroup
        
        //4: ground shouldn't move, so making it static
        groundBody.type = CCPhysicsBodyType.Static
        
        //5: Setting bounciness of the ground
        groundBody.elasticity = 1.5
        
        //6: Linking ground sprite to physics body
        _ground!.physicsBody = groundBody
        
        //7: placing ground at the bottom on the screen
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        _ground!.anchorPoint = ccp(0.5, 0)
        _ground!.position = ccp(viewSize.width * 0.5, 0)
        
        //8: add to batch node since it uses sprite from batch node
        _batchNodeMain?.addChild(_ground, z: kGroundZ)
    }
    
    func spawnStone() {
        
        
        //1: Stone sprite
        let stone:CCSprite = CCSprite.spriteWithImageNamed("stone.png") as! CCSprite
        
        //2: We'll use circle shape of the radius for simulation
        let radius:CGFloat = stone.contentSizeInPoints.width * 0.5
        
        //3: Creating body using circular share
        let stoneBody:CCPhysicsBody = CCPhysicsBody(circleOfRadius: radius, andCenter: stone.anchorPointInPoints)
        
        //4: Setting stone mass
        stoneBody.mass = 10.0
        
        stoneBody.collisionType = "stone"
        //stoneBody.collisionMask = ["hunters"]
        
        
        //5: Stone will be affected by gravity and other forces, so setting it to dynamic
        stoneBody.type = CCPhysicsBodyType.Dynamic
        
        //6: Linking sprite with physics body
        stone.physicsBody = stoneBody
        //stone.physicsBody = stoneBody
        
        //7 Adding to batch node, because sprite uses frame from batchnode
        _batchNodeMain!.addChild(stone, z: kObjectsZ)
        
        //8 Placing in it initial position (it will start its falling from here)
        //let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        //stone.position = ccp(viewSize.width * 0.5, viewSize.height * 0.9)
        _stones! += [stone]
        self.launchBirdWithStone(stone)
    }
    
    func launchStone(stone:CCSprite) {
        //1
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        stone.position = ccp(viewSize.width * 0.5, viewSize.height * 0.9)
        
        //2
        let xImpulseMin:Float = -1200.0
        let xImpulseMax:UInt32 = 1200
        let yImpulse:Float = 2000.0
        let xImpulse:Float = xImpulseMin + 2.0 * Float(arc4random_uniform(xImpulseMax))
        
        //3
        stone.physicsBody.applyImpulse(ccp(CGFloat(xImpulse), CGFloat(yImpulse)))
        
    }
    
    func launchBirdWithStone(stone:CCSprite) {
        //1: Creating bird sprite
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        let bird:PhysicsBird = PhysicsBird(birdType2: Bird.BirdType.BirdTypeBig)
        bird.position = ccp(viewSize.width * 1.1, viewSize.height * 0.9)
        _batchNodeBirds?.addChild(bird)
        
        //2: Aiming at the hunter in his current position
        let targetPosition = _hunter?.position
        
        //3: Giving the stone to the bird and making it fly into the scene
        bird.flyAndDropStoneAt(targetPosition!, stone: stone)
    }
    
    func addBoundaries() {
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        let boundRect:CGRect = CGRectMake(0, 0, 20, viewSize.height * 0.25)
        
        let leftBound:CCNode = CCNode()
        leftBound.position = ccp(0, (_ground?.contentSize.height)! + 30)
        leftBound.contentSize = boundRect.size
        
        let leftBody:CCPhysicsBody = CCPhysicsBody(rect: boundRect, cornerRadius: 0)
        leftBody.type = CCPhysicsBodyType.Static
        leftBound.physicsBody = leftBody
        
        _physicsNode?.addChild(leftBound)
        
        let rightBound:CCNode = CCNode()
        rightBound.contentSize = boundRect.size
        rightBound.anchorPoint = ccp(1.0, 0)
        rightBound.position = ccp(viewSize.width, leftBound.position.y)
        
        let rightBody:CCPhysicsBody = CCPhysicsBody(rect: boundRect, cornerRadius: 0)
        rightBody.type = CCPhysicsBodyType.Static
        rightBound.physicsBody = rightBody
        
        _physicsNode?.addChild(rightBound)
        
        
    }
    
    override func onEnter() {
        super.onEnter()
        _stones = []
        _timeUntilNextStone = 2.0
        _stoneGroundCollisionGroup = NSObject()
        self.createPhysicsNode()
        self.createBatchNodes()
        self.addBackground()
        self.addGround()
        
    }
    
    override func onEnterTransitionDidFinish() {
        super.onEnterTransitionDidFinish()
        self.createHunter()
        self.spawnStone()
        self.addBoundaries()
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        //This is just to restart the game when the hunter dies by touching the screen
        if (_hunter!._state == PhysicsHunter.PhysicsHunterState.PhysicsHunterStateDead) {
            CCDirector.sharedDirector().replaceScene(PhysicsScene())
            return
        }
        
        
        
        let touchLocation:CGPoint = touch.locationInNode(self)
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        
        if (touchLocation.x >= viewSize.width * 0.5) {
            _hunter?.runAtDirection(PhysicsHunter.PhysicsHunterRunDirection.PhysicsHunterRunDirectionRight)
        } else {
            _hunter?.runAtDirection(PhysicsHunter.PhysicsHunterRunDirection.PhysicsHunterRunDirectionLeft)
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        _hunter?.stop()
    }
    
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!,  hunter: CCNode!,  stone: CCNode!) -> Bool {
        _hunter?.die()
        return true
    }
    
    override func fixedUpdate(dt: CCTime) {
        let stonesCpy = _stones
        for (index, stone) in stonesCpy!.enumerate() {
            if (stone.position.y < -10) {
                _stones?.removeAtIndex(index)
                stone.removeFromParentAndCleanup(true)
            }
            
        }
        
        if (_hunter?._state != PhysicsHunter.PhysicsHunterState.PhysicsHunterStateDead) {
            _timeUntilNextStone! -= Float(dt)
            if (_timeUntilNextStone <= 0) {
                _timeUntilNextStone = 1.0 + Float(arc4random_uniform(1))
                self.spawnStone()
            }
        }
    }
    
    
}