//
//  Hunter.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 3/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Hunter : CCSprite {
    
    private var _torso: CCSprite  = CCSprite.spriteWithImageNamed("hunter_top_0.png") as! CCSprite;
    
    var hunterState:HunterState! = nil;
    
    enum HunterState {
        case HunterStateIdle
        case HunterStateAiming
        case HunterStateReloading
    }
    
    
    
    override convenience init() {
        self.init(imageNamed: "hunter_bottom.png");
        
        self.hunterState = HunterState.HunterStateIdle;
        
        _torso.anchorPoint = ccp(0.5, 10.0/44.0);
        
        _torso.position = ccp(self.boundingBox().size.width/2.0, self.boundingBox().size.height);
        
        self.addChild(_torso, z: -1);
    }
    
    func torsoRotation()-> Float {
        return _torso.rotation;
    }
    
    func torsoCenterInWorldCoordinates() -> CGPoint?{
        let torsoCenterLocal: CGPoint = ccp(_torso.contentSize.width / 2.0, _torso.contentSize.height/2.0);
        
        let torsoCenterWorld: CGPoint = _torso.convertToWorldSpace(torsoCenterLocal);
        return torsoCenterWorld;
    }
    private func calculateTorsoRotationToLookAtPoint(targetPoint:CGPoint) ->Float {
        //1
        let torsoCenterWorld:CGPoint = self.torsoCenterInWorldCoordinates()!;
        
        //2
        let pointStraightAhead:CGPoint = ccp(torsoCenterWorld.x + 1.0, torsoCenterWorld.y);
        
        //3
        let forwardVector:CGPoint = ccpSub(pointStraightAhead, torsoCenterWorld);
        
        //4
        let targetVector = ccpSub(targetPoint, torsoCenterWorld);
        
        //5
        let angleRadians = ccpAngleSigned(forwardVector, targetVector);
        
        //6
        var angleDegrees = -1 * CC_RADIANS_TO_DEGREES(angleRadians);
        
        //7
        angleDegrees = clampf(angleDegrees, -60, 25);
        
        return angleDegrees;
    }
    
    func aimAtPoint(point: CGPoint) {
        if (hunterState != HunterState.HunterStateReloading ) {
            hunterState = HunterState.HunterStateAiming;
        }
        
        _torso.rotation = self.calculateTorsoRotationToLookAtPoint(point);
        
    }
    
    func shootAtPoint(point:CGPoint)->CCSprite? {
        AudioManager.sharedAudioManager.playSoundEffect("arrow_shot.wav")
        //Updating target to the latest point
        self.aimAtPoint(point);
        //Create arrow image
        let arrow:CCSprite = CCSprite.spriteWithImageNamed("arrow.png") as! CCSprite;
        
        //Setting anchor point to the tail of arrow
        arrow.anchorPoint = ccp(0.0, 0.5);
        
        //Placing arrow in hand of the hunter
        let torsoCenterGlobal:CGPoint = self.torsoCenterInWorldCoordinates()!;
        arrow.position = torsoCenterGlobal;
        arrow.rotation = _torso.rotation;
        //Adding arrow to the self.parent
        self.parent!.addChild(arrow);
        
        //Finding the direction of the arrow
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
        let forwardVector:CGPoint = ccp(1.0, 0.0);
        let angleRadians:Float = -1 * CC_DEGREES_TO_RADIANS(_torso.rotation);
        
        //Creating movement trajectory that ends off screen
        var arrowMovementVector:CGPoint = ccpRotateByAngle(forwardVector, CGPointZero, angleRadians);
        arrowMovementVector = ccpNormalize(arrowMovementVector);
        arrowMovementVector = ccpMult(arrowMovementVector, viewSize.width * 2.0)
        
        //Running move action
        let moveAction:CCActionMoveBy = CCActionMoveBy.actionWithDuration(2.0, position: arrowMovementVector) as! CCActionMoveBy;
        
        arrow.runAction(moveAction);
        
        self.reloadArrow();
        
        return arrow;
        
    }
    
    func getReadyToShootAgain() {
        self.hunterState = HunterState.HunterStateIdle;
    }
    
    func reloadArrow() {
        //1
        self.hunterState = HunterState.HunterStateReloading;
        
        //2
        let frameNameFormat:String = "hunter_top_%d.png";
        let frames:NSMutableArray = NSMutableArray();
        
        for var i = 0; i < 6; i++ {
            let frameName:String = String.localizedStringWithFormat(frameNameFormat, i);
            let frame:CCSpriteFrame! = CCSpriteFrame(imageNamed: frameName)
            frames.addObject(frame);
        }
        
        //3
        
        let reloadAnimation:CCAnimation! = CCAnimation(spriteFrames: frames as [AnyObject], delay: 0.05)
        reloadAnimation.restoreOriginalFrame = true;
        let reloadAnimAction:CCActionAnimate! = CCActionAnimate.actionWithAnimation(reloadAnimation) as! CCActionAnimate;
        
        //4
        let readyToShootAgain:CCActionCallFunc! = CCActionCallFunc.actionWithTarget(self, selector: "getReadyToShootAgain") as! CCActionCallFunc;
        
        //5
        let delay:CCActionDelay! = CCActionDelay.actionWithDuration(0.25) as! CCActionDelay;
        
        //6
        let reloadAndGetReady:CCActionSequence! = CCActionSequence.actionWithArray([reloadAnimAction, delay, readyToShootAgain]) as! CCActionSequence;
        
        //7
        _torso.runAction(reloadAndGetReady);
    }
    
    
    
}
