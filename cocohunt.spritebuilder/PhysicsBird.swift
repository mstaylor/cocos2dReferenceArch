//
//  PhysicsBird.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 10/9/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation

class PhysicsBird : Bird {
    
    private var _stoneToDrop:CCSprite? = nil
    //Current state of the bird
    private var _state:PhysicsBirdState? = nil
    //The point where the bird should drop the stone
    private var _targetPoint:CGPoint? = nil
    //Joint holding the stone
    private var _stoneJoint:CCPhysicsJoint? = nil
    
    
    enum PhysicsBirdState : Int {
        case PhysicsBirdStateIdle
        case PhysicsBirdStateFlyingIn
        case PhysicsBirdStateFlyingOut
    }
    
     convenience init(birdType2: BirdType) {
        
            //step 1: reuse bird's init method to create a bird
            self.init(birdType: birdType2)
            //step 2: creating a physics body for the bird itself (to apply force to it and attach a stone using a joint
            _state = PhysicsBirdState.PhysicsBirdStateIdle
            let body:CCPhysicsBody = CCPhysicsBody(circleOfRadius: self.contentSize.height * 0.3, andCenter: self.anchorPointInPoints)
            
            body.collisionType = "bird"
            body.type = CCPhysicsBodyType.Dynamic
            body.mass = 30.0
            self.physicsBody = body
    }
    
    
    
    func flyAndDropStoneAt(point: CGPoint, stone:CCSprite) {
        //1: Starting to fly in
        _state = PhysicsBirdState.PhysicsBirdStateFlyingIn
        _targetPoint = point
        self._stoneToDrop = stone
        
        //2: At the start stone is not colliding with anything, so that it didn't hit the bird if swings too high
        
        self._stoneToDrop?.physicsBody.collisionMask = []
        self.physicsBody.collisionMask = []
        
        //3: Calculating the distance
        let distanceToHoldTheStone = self.contentSize.height * 0.5
        self._stoneToDrop?.position = ccpSub(self.position, ccp(0, distanceToHoldTheStone))
        
        //4
        _stoneJoint = CCPhysicsJoint(distanceJointWithBodyA: self.physicsBody, bodyB: stone.physicsBody, anchorA: self.anchorPointInPoints, anchorB: stone.anchorPointInPoints)
    }
    
    override func fixedUpdate(dt: CCTime) {
        //1: Calculating vertical force to hold the bird in the air
        let forceToHoldBird = -1 * (self._stoneToDrop?.physicsBody.mass)! * self.physicsNode().gravity.y
        
        //2: Checking the bird state
        if (_state == PhysicsBirdState.PhysicsBirdStateFlyingIn) {
            //3: If bird is flying then it carries a stone.  Adding vertical force to hold the stone
            let forceToHoldStone = -1 * (self._stoneToDrop?.physicsBody.mass)! * self.physicsNode().gravity.y
            
            //4: Total force to hold the bird and the stone (joint weights nothing)
            let forceUp = forceToHoldBird + forceToHoldStone
            
            //5: Applying force to the bird to keep it in the air
            self.physicsBody.applyForce(ccp(-1500, forceUp))
            
            //6: If reached target point dropping the stone and switching to next state.
            if (self.position.x <= _targetPoint?.x) {
                _state = PhysicsBirdState.PhysicsBirdStateFlyingOut
                self.dropStone()
            }
        } else if (_state == PhysicsBirdState.PhysicsBirdStateFlyingOut) {
            //7: Making bird to fly up
            let forceUp = forceToHoldBird * 1.5
            
            //8: Applying force to fly up
            self.physicsBody.applyForce(ccp(0, forceUp))
            
            //9: Checking if the bird left the screen
            let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
            if (self.position.y > viewSize.height) {
                self.removeFromParentAndCleanup(true)
            }
        }
    }
    
    func dropStone() {
       self._stoneToDrop?.physicsBody.collisionMask = nil
        _stoneJoint?.invalidate()
    }
    
    
}
