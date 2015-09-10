//
//  AboutScene.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 8/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class AboutScene : CCScene {
    
    
    override init() {
        super.init();
        addBackground()
        addText()
        addBackButton()
        addVisitWebSiteButton()
        
    }
    
    func addBackground() {
        let bg:CCSprite = CCSprite.spriteWithImageNamed("about_bg.png") as! CCSprite
        bg.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        bg.position = ccp(0.5, 0.5)
        self.addChild(bg)
    }
    
    func addText() {
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        let aboutText = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        let aboutFont = "AppleSDGothicNeo-Medium"
        
        let aboutFontSize = 14
        
        let aboutTextRect:CGSize = CGSizeMake(viewSize.width * 0.8, viewSize.height * 0.6)
        
        let aboutLabel:CCLabelTTF = CCLabelTTF.labelWithString(aboutText, fontName: aboutFont, fontSize: CGFloat(aboutFontSize), dimensions: aboutTextRect) as! CCLabelTTF
        
        aboutLabel.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        aboutLabel.position = ccp(0.5, 0.3)
        aboutLabel.color = CCColor.orangeColor()
        aboutLabel.shadowColor = CCColor.grayColor()
        aboutLabel.shadowBlurRadius = 1.0
        aboutLabel.shadowOffset = ccp(1.0, -1.0)
        self.addChild(aboutLabel)
    }
    
    func addVisitWebSiteButton() {
        let normal:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_9slice.png") as! CCSpriteFrame
        let pressed:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_9slice_pressed.png") as! CCSpriteFrame
        let btnVisitWebsite:CCButton = CCButton.buttonWithTitle("Visit Web Site", spriteFrame: normal, highlightedSpriteFrame: pressed, disabledSpriteFrame: nil) as! CCButton
        btnVisitWebsite.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnVisitWebsite.position = ccp(0.5, 0.1)
        
        btnVisitWebsite.horizontalPadding = 12.0
        btnVisitWebsite.verticalPadding = 4.0
        btnVisitWebsite.label.fontName = "HelveticaNeue-Bold"
        btnVisitWebsite.block = {(AnyObject) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.google.com")!)}
        self.addChild(btnVisitWebsite)
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
        let transition:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().popSceneWithTransition(transition)
    }
    
    
}


