//
//  LevelSelectScene.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 9/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class LevelSelectScene : CCScene {
    let kLevelHunting:String = "hunting"
    let kLevelDodging:String = "dodging"
    
    override init() {
        super.init();
        addBackground()
        addBackButton()
        addScroll()
    }
    
    func addBackground() {
        let bg:CCSprite = CCSprite.spriteWithImageNamed("level_select_bg.png") as! CCSprite
        bg.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        bg.position = ccp(0.5, 0.5)
        self.addChild(bg)
    }
    
    
    func addBackButton() {
        let backNormalImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_back.png") as! CCSpriteFrame
        let backHighlightedImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_back_pressed.png") as! CCSpriteFrame
        let btnBack:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: backNormalImage, highlightedSpriteFrame: backHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        btnBack.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnBack.position = ccp(0.1, 0.9)
        btnBack.setTarget(self, selector: "backTapped")
        self.addChild(btnBack)
        
    }
    
    func backTapped() {
        let transition:CCTransition = CCTransition(pushWithDirection: CCTransitionDirection.Down, duration: 1.0)
        let scene:MenuScene = MenuScene()
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
    }
    
    func addScroll() {
        //1
        let levels = 10
        
        //2
        let scrollViewContents:CCNode = CCNode.node() as! CCNode
        scrollViewContents.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Normalized)
        scrollViewContents.contentSize = CGSizeMake(CGFloat(levels), CGFloat(1))
        for var i = 0; i < levels; i++ {
            //3
            var level:CCButton
            if (i % 2 == 0) {
              let levelImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("hunting_level.png") as! CCSpriteFrame
              level = CCButton.buttonWithTitle(nil, spriteFrame: levelImage) as! CCButton
              level.name = kLevelHunting
            } else {
                let levelImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("dodging_level.png") as! CCSpriteFrame
                level = CCButton.buttonWithTitle(nil, spriteFrame: levelImage) as! CCButton
                level.name = kLevelDodging
            }
            
            level.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
            level.position = ccp((CGFloat(i) + 0.5)/CGFloat(levels), CGFloat(0.5))
            
            //4
            level.setTarget(self, selector: "levelTapped:")
            
            //5
            scrollViewContents.addChild(level)
        }
        
        //6
        let scrollView:CCScrollView = CCScrollView(contentNode: scrollViewContents)
        
        //7
        scrollView.pagingEnabled = true
        
        //8
        scrollView.horizontalScrollEnabled = true
        scrollView.verticalScrollEnabled = false
        
        self.addChild(scrollView)
        
    }
    
    func levelTapped(sender: AnyObject) {
        let levelName:String = (sender as! CCButton).name
        if (levelName == kLevelHunting) {
            let scene:GameScene = GameScene()
            let transition:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
            CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
        } else {
            NSLog("Level not implemented: %@", levelName)
        }
        
    }
    
}