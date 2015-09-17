//
//  LoadingScene.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 9/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class LoadingScene:CCScene {
    override init() {
        super.init();
        let loading:CCLabelTTF = CCLabelTTF.labelWithString("Loading...", fontName: "Georgia-BoldItalic", fontSize: 24) as! CCLabelTTF
        loading.anchorPoint = ccp(0.5, 0.5)
        loading.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        loading.position = ccp(0.5, 0.5)
        self.addChild(loading)
    }
    
    override func onEnterTransitionDidFinish() {
        super.onEnterTransitionDidFinish()
        let transition:CCTransition = CCTransition(revealWithDirection: CCTransitionDirection.Down, duration: 1.0)
        let scene:GameScene = GameScene()
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
    }
}
