//
//  IntroScene.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class IntroScene :  CCScene {
    
    private var _explodingCoconut: CCSprite? = nil;
    
    override init() {
        super.init();
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
        _explodingCoconut = (CCSprite.spriteWithImageNamed("Exploding_Coconut_0.png") as! CCSprite);
        _explodingCoconut!.position = ccp(viewSize.width * 0.5, viewSize.height * 0.5);
        self.addChild(_explodingCoconut);
    }
    
    override func onEnter() {
        super.onEnter();
        animateCoconutExplosion();
        AudioManager.sharedAudioManager.preloadSoundEffects()
        
    }
    
    private func animateCoconutExplosion() {
        let frames:NSMutableArray = NSMutableArray();
        let lastFrameNumber = 34;
        for var i = 0; i <= lastFrameNumber; i++ {
            let frameName = String.localizedStringWithFormat("Exploding_Coconut_%d.png", i);
            let frame:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed(frameName) as! CCSpriteFrame;
            frames.addObject(frame);
        }
        
        let explosion:CCAnimation = CCAnimation.animationWithSpriteFrames(frames as [AnyObject], delay: 0.15) as! CCAnimation;
        
        let animateExplosion: CCActionAnimate = CCActionAnimate.actionWithAnimation(explosion) as! CCActionAnimate;
        
        let easedExplosion: CCActionEaseIn = CCActionEaseIn.actionWithAction(animateExplosion, rate: 1.5) as! CCActionEaseIn;
        
        let proceedToGameScene:CCActionCallFunc = CCActionCallFunc.actionWithTarget(self, selector: "proceedToGameScene") as! CCActionCallFunc;
        
        let sequence: CCActionSequence = CCActionSequence.actionWithArray([easedExplosion, proceedToGameScene]) as! CCActionSequence;
        
        _explodingCoconut?.runAction(sequence);
        
        
        
    }
    
    func proceedToGameScene() {
        CCDirector.sharedDirector().replaceScene(MenuScene())
    }
    
}
