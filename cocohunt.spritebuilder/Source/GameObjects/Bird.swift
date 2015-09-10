//
//  Bird.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 3/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Bird : CCSprite {
    
    private var birdType: BirdType? = nil;
    
    var birdState: BirdState? = nil;
    
    private var _timesToVisit:Int? = nil;
    
    
    
    
    
    enum BirdType : Int {
        case BirdTypeBig
        case BirdTypeMedium
        case BirdTypeSmall
    }
    
    enum BirdState {
        case BirdStateFlyingIn
        case BirdStateFlyingOut
        case BirdStateFlewOut
        case BirdStateDead
    }
    
    convenience init(birdType: BirdType) {
        
        var birdImageName : String?
        
        switch birdType {
            case .BirdTypeBig:
                birdImageName = "bird_big_0.png"
            case .BirdTypeMedium:
                birdImageName = "bird_small_0.png"
            case .BirdTypeSmall:
                birdImageName = "bird_small_0.png"
            default:
                NSLog("Unknown bird type, using small bird!")
                birdImageName = "bird_small_0.png";
        }
        
        self.init(imageNamed: birdImageName!);
        _timesToVisit = 1;
        self.birdState = BirdState.BirdStateFlyingIn;
        self.birdType = birdType;
        self.animateFly();
    }
    
    func removeBird(hitByArrow: Bool)-> Int {
        //self.removeFromParentAndCleanup(true);
        self.stopAllActions();
        
        var score:Int = 0;
        
        if (hitByArrow == true) {
            self.birdState = BirdState.BirdStateDead;
            score = (_timesToVisit! + 1) * 5;
            self.displayPoints(score);
            self.animateFall();
            self.explodeFeathers();
            AudioManager.sharedAudioManager.playSoundEffect("bird_hit.mp3", withPosition:self.position)
        } else {
            self.birdState = BirdState.BirdStateFlewOut;
            self.removeFromParentAndCleanup(true);

            
        }
        return score;
        
    }
    
    func turnaround() {
        self.flipX = !self.flipX;
        if (self.flipX) {
            _timesToVisit!--;
        }
        if (_timesToVisit <= 0) {
            self.birdState = BirdState.BirdStateFlyingOut;
        }
    }
    
    private func animateFly() {
        var animFrameNameFormat:String! = nil;
        switch(birdType!) {
            case BirdType.BirdTypeBig:
                animFrameNameFormat = "bird_big_%d.png";
            case BirdType.BirdTypeMedium:
                animFrameNameFormat = "bird_middle_%d.png"
            case BirdType.BirdTypeSmall:
                animFrameNameFormat = "bird_small_%d.png"
            
            default:
                NSLog("Unknown bird type, using small bird!")
                animFrameNameFormat = "bird_small_%d.png"
        }
        
        let animFrames: NSMutableArray = NSMutableArray(capacity: 7);
        for i in 0...6 {
            let currentFrameName: String = String(format: animFrameNameFormat, i);
            
            let animationFrame: CCSpriteFrame! = CCSpriteFrame.frameWithImageNamed(currentFrameName) as! CCSpriteFrame;
            
            animFrames.addObject(animationFrame);
            
            
        }
        
        let flyAnimation:CCAnimation! = CCAnimation.animationWithSpriteFrames(animFrames as [AnyObject], delay: 0.1) as! CCAnimation;
        
        let flyAnimateAction:CCActionAnimate! = CCActionAnimate.actionWithAnimation(flyAnimation) as! CCActionAnimate;
        
        let flyForever: CCActionRepeatForever = CCActionRepeatForever.actionWithAction(flyAnimateAction) as! CCActionRepeatForever;
        
        self.runAction(flyForever);
        
    }
    
    private func animateFall() {
        
        //falling
        let fallDownOffScreenPoint:CGPoint = ccp(self.position.x, -self.boundingBox().size.height);
        let fallOffScreen:CCActionMoveTo = CCActionMoveTo.actionWithDuration(2.0, position: fallDownOffScreenPoint) as! CCActionMoveTo;
        let removeWhenDone:CCActionRemove = CCActionRemove.action() as! CCActionRemove;
        let fallSequence:CCActionSequence = CCActionSequence.actionWithArray([fallOffScreen, removeWhenDone]) as! CCActionSequence;
        self.runAction(fallSequence);
        
        //Rotating
        let rotate:CCActionRotateBy = CCActionRotateBy.actionWithDuration(0.1, angle: 60.0) as! CCActionRotateBy;
        let rotateForever:CCActionRepeatForever = CCActionRepeatForever.actionWithAction(rotate) as!CCActionRepeatForever;
        self.runAction(rotateForever);
        
        
        
    }
    
    private func explodeFeathers() {
        //Total num of particles
        let totalNumberofFeathers:UInt = 100;
        
        //creating particle system
        let explosion:CCParticleSystem = CCParticleSystem.particleWithTotalParticles(totalNumberofFeathers) as!CCParticleSystem;
        
        //setting position to the bird center
        explosion.position = self.position;
        
        //using gravity mode for explosion
        explosion.emitterMode = CCParticleSystemMode.Gravity;
        
        //making feathers to fall down a bit, since the will be affected by world's gravity
        explosion.gravity = ccp(0, -200.0);
        
        //explosion should have a really small duration
        explosion.duration = 0.1;
        
        //calculating rate
        explosion.emissionRate = Float(totalNumberofFeathers)/explosion.duration;
        
        //Setting texture and start and end color---feathers will be white, slowly fading out to 0 alpha
        explosion.texture = CCTexture(file: "feather.png");
        explosion.startColor = CCColor.whiteColor();
        explosion.endColor = CCColor.whiteColor().colorWithAlphaComponent(0.0);
        
        //setting parameter of how far and how fast the feathers will move away from center
        explosion.life = 0.25;
        explosion.lifeVar = 0.75;
        explosion.speed = 60;
        explosion.speedVar = 80;
        
        //setting start/end size of particles
        explosion.startSize = 16;
        explosion.startSizeVar = 4;
        explosion.endSize = Float(CCParticleSystemStartSizeEqualToEndSize);
        explosion.endSizeVar = 8;
        
        //adding random starting angle and random rotation
        explosion.angleVar = 360;
        explosion.startSpinVar = 360;
        explosion.endSpinVar = 360;
        
        //telling particle system to remove it from the scene automatically in the end
        explosion.autoRemoveOnFinish = true;
        //13setting how particles should blend with the background
        var blendFunc:ccBlendFunc = ccBlendFunc();
        blendFunc.src = UInt32(GL_SRC_ALPHA);
        blendFunc.dst = UInt32(GL_ONE);
        
        explosion.blendMode = CCBlendMode(options: ["CCBlendFuncSrcColor" : Int(blendFunc.src), "CCBlendFuncDstColor" : Int(blendFunc.dst)])
        
        //14 Finding scene and addint particle system to it
        let batchNode:CCNode = self.parent
        let scene:CCNode = batchNode.parent
        scene.addChild(explosion)
        
        
    }
    
    
    private func displayPoints(amount:Int?) {
        //1 Create bitmap font using points.fnt
        let ptsStr:String = String.localizedStringWithFormat("%d", amount!);
        let ptsLabel:CCLabelBMFont = CCLabelBMFont.labelWithString(ptsStr, fntFile: "points.fnt") as! CCLabelBMFont;
        ptsLabel.position = self.position;
        
        //2 Finding scene (which is parent of batch node and batch node is parent of the bird
        let batchNode:CCNode? = parent;
        let scene:CCNode? = batchNode?.parent;
        scene?.addChild(ptsLabel);
        
        
        //3 Configuring the bezier curve
        let xDelta1 = CGFloat(10);
        let yDelta1 = CGFloat(5);
        let yDelta2 = CGFloat(10);
        let yDelta4 = CGFloat(20);
        var curve:ccBezierConfig = ccBezierConfig(endPosition: ccp(ptsLabel.position.x, ptsLabel.position.y + yDelta4), controlPoint_1: ccp(ptsLabel.position.x + xDelta1, ptsLabel.position.y + yDelta2), controlPoint_2: ccp(ptsLabel.position.x - xDelta1 , ptsLabel.position.y + yDelta1));
        
        //4 total duration of label floating
        let  baseDuration = 1.0;
        
        //5 Move along the bezier curve
        let bezierMove:CCActionBezierTo = CCActionBezierTo.actionWithDuration(baseDuration, bezier: curve) as! CCActionBezierTo;
        
        //6 start fade out in final 25% of movement
        let fadeOut:CCActionFadeOut = CCActionFadeOut.actionWithDuration(baseDuration * 0.25) as! CCActionFadeOut;
        
        //7 delaying fading out, to allow the label move 75% of the baseDuration fully visible
        let delay:CCActionDelay = CCActionDelay.actionWithDuration(baseDuration * 0.75) as! CCActionDelay;
        
        //8 Creating sequence: delay, then fade out
        let delayAndFade:CCActionSequence = CCActionSequence.actionWithArray([delay, fadeOut]) as! CCActionSequence;
        
        //9 Creating action to run move + (delay then fade) actions simultaneously
        let bezieAndFadeOut:CCActionSpawn = CCActionSpawn.actionWithArray([bezierMove, delayAndFade]) as! CCActionSpawn;
        
        
        //Remove label in the end.
        let removeInTheEnd:CCActionRemove = CCActionRemove.action() as! CCActionRemove;
        
        //11 Creating final complex sequence
        let actions:CCActionSequence = CCActionSequence.actionWithArray([bezieAndFadeOut, removeInTheEnd]) as! CCActionSequence;
        
        //12 Running the final sequence
        ptsLabel.runAction(actions);
        
    }
    
    
}
