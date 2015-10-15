//
//  PhysicsHunter.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 10/6/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation

class PhysicsHunter : CCSprite {
    
    enum PhysicsHunterState : Int {
        case PhysicsHunterStateIdle
        case PhysicsHunterStateRunning
        case PhysicsHunterStateDead
    }
    
    enum PhysicsHunterRunDirection : Int {
        case PhysicsHunterRunDirectionLeft
        case PhysicsHunterRunDirectionRight
    }
    
    let kHunterMovementSpeed = CGFloat(90.0)
    
    var _state: PhysicsHunterState? = nil
    
    var _runAnimation:CCAnimation? = nil
    
    var _idleAnimation:CCAnimation? = nil
    
    var _runningDirection:PhysicsHunterRunDirection? = nil
    
    
    override convenience init() {
        
        self.init(imageNamed: "physics_hunter_idle_00.png")
        _state = PhysicsHunterState.PhysicsHunterStateIdle
        self.createAnimations()
        self.createPhysicsBody()
    }
    
    
    
    override func onEnter() {
        super.onEnter()
        self.playIdleAnimation()
    }
    
    func createAnimations() {
        var runFrames:[CCSpriteFrame] = []
        for var i = 0; i < 3; i++ {
            let frame:CCSpriteFrame = CCSpriteFrame(imageNamed: String.init(format: "physics_hunter_run_%.2d.png", i))
            runFrames += [frame]
        }
        
        _runAnimation = CCAnimation(spriteFrames: runFrames, delay: 0.075)
        
        var idleFrames:[CCSpriteFrame] = []
        
        for var i = 0; i < 3; i++ {
            let frame:CCSpriteFrame = CCSpriteFrame(imageNamed: String.init(format: "physics_hunter_idle_%.2d.png", i))
            idleFrames += [frame]
        }
        
        _idleAnimation = CCAnimation(spriteFrames: idleFrames, delay: 0.2)
        
    }
    
    func createPhysicsBody() {
        //Pill shape bottom point
        let from:CGPoint = ccp(self.contentSizeInPoints.width * 0.5, self.contentSizeInPoints.height * 0.15)
        
        //Pill shape top point
        let to:CGPoint = ccp(self.contentSizeInPoints.width * 0.5, self.contentSizeInPoints.height * 0.85)
        
        //Creating hunter body using pill shape
        let body:CCPhysicsBody = CCPhysicsBody(pillFrom: from, to: to, cornerRadius: 8.0)
        
        //Not allowing hunter to rotate or he'll fall on the side
        body.allowsRotation = false
        
        //fixing hunter sliding too much
        body.friction = 3.0
        
        body.collisionType = "hunter"
        
        //Linking hunter with its physics body
        self.physicsBody = body
        
        
    }
    
    func runAtDirection(direction:PhysicsHunterRunDirection) {
        if (_state != PhysicsHunterState.PhysicsHunterStateIdle) {
            return
        }
        
        _runningDirection = direction
        _state = PhysicsHunterState.PhysicsHunterStateRunning
        self.planRunAnimation()
        
    }
    
    func stop() {
        if (_state != PhysicsHunterState.PhysicsHunterStateRunning) {
            return
        }
        
        _state = PhysicsHunterState.PhysicsHunterStateIdle
        self.playIdleAnimation()
        
    }
    
    func planRunAnimation() {
        self.stopAllActions()
        if (_runningDirection == PhysicsHunterRunDirection.PhysicsHunterRunDirectionRight) {
            self.flipX = false
        } else {
            self.flipX = true
        }
        
        let animateRun:CCActionAnimate = CCActionAnimate(animation: _runAnimation)
        let runForever:CCActionRepeatForever = CCActionRepeatForever(action: animateRun)
        self.runAction(runForever)
    }
    
    func playIdleAnimation() {
        self.stopAllActions()
        let animateIdle:CCActionAnimate = CCActionAnimate(animation: _idleAnimation)
        let idleForever:CCActionRepeatForever = CCActionRepeatForever(action: animateIdle)
        self.runAction(idleForever)
    }
    
    override func fixedUpdate(delta: CCTime) {
        if (_state == PhysicsHunterState.PhysicsHunterStateRunning) {
            var newVelocity:CGPoint = self.physicsBody.velocity
            if (_runningDirection == PhysicsHunterRunDirection.PhysicsHunterRunDirectionRight) {
                newVelocity.x = kHunterMovementSpeed
            } else {
                newVelocity.x = -1 * kHunterMovementSpeed
            }
            self.physicsBody.velocity = newVelocity
        }
    }
    
    func die() {
        if (_state != PhysicsHunterState.PhysicsHunterStateDead) {
            let explode:CCParticleExplosion = CCParticleExplosion()
            explode.texture = CCTexture(file: "feather.png")
            explode.positionType = self.positionType
            explode.position = self.position
            
            CCDirector.sharedDirector().runningScene.addChild(explode)
            self.removeFromParentAndCleanup(true)
        }
        
        _state = PhysicsHunterState.PhysicsHunterStateDead
    }
    
    
    
}
