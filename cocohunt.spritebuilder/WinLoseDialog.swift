//
//  WinLoseDialog.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 9/17/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation
class WinLoseDialog : CCNode {
    
    let kKeyFont = "HelveticaNeue"
    let kKeyFontSize = 12
    let kKeyX = 0.2
    
    let kValueFont = "HelveticaNeue-Bold"
    let kValueFontSize = 12
    let kValueX = 0.8
    
    let kLine1Y = 0.7
    let kMarginBetweenLines = 0.08
    
    var _currenStats:GameStats? = nil
    
    init(stats:GameStats) {
        super.init()
        _currenStats = stats
        self.setupModalDialog()
        self.createDialogLayout()
        if (HighscoreManager.sharedHighscoreManager.isHighscore((_currenStats?.score)!)) {
            let hsDialog:HighScoreDialog = HighScoreDialog(stats: _currenStats!)
            hsDialog.onCloseBlock = {
                Void in
                 self.createDialogLayout()
            }
            self.addChild(hsDialog)
        } else {
            self.createDialogLayout()
        }
    }
    
    func setupModalDialog() {
       self.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Normalized)
        self.contentSize = CGSizeMake(1, 1)
        self.userInteractionEnabled = true
    }
    
    
    func createDialogLayout() {
        let bg:CCSprite = CCSprite.spriteWithImageNamed("win_lose_dialog_bg.png") as! CCSprite
        bg.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        bg.position = ccp(0.5, 0.5)
        self.addChild(bg)
        
        let stats:Dictionary<String, String> = ["Score": String.localizedStringWithFormat("%d", (_currenStats?.score)!),
            "Lives Left" : String.localizedStringWithFormat("%d", (_currenStats?.lives)!),
            "Time Spent" : String.localizedStringWithFormat("%d", (_currenStats?.timeSpent)!)]
        
        var margin:CGFloat = 0
        let fontColor:CCColor = CCColor.orangeColor()
        
        for (key, value) in stats {
            let lblKey:CCLabelTTF = CCLabelTTF.labelWithString(key, fontName: kKeyFont, fontSize: CGFloat(kKeyFontSize)) as! CCLabelTTF
            lblKey.color = fontColor
            lblKey.anchorPoint = ccp(0.0, 0.5)
            lblKey.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
            lblKey.position = ccp(CGFloat(kKeyX), CGFloat(kLine1Y) - margin)
            bg.addChild(lblKey)
            
            let lblValue:CCLabelTTF = CCLabelTTF.labelWithString(value, fontName: kValueFont, fontSize: CGFloat(kValueFontSize)) as! CCLabelTTF
            lblValue.color = fontColor
            lblValue.anchorPoint = ccp(1.0, 0.5)
            lblValue.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
            lblValue.position = ccp(CGFloat(kValueX), CGFloat(kLine1Y) - margin)
            bg.addChild(lblValue)
            
            margin += CGFloat(kMarginBetweenLines)
            
        }
        
        let restartNormalImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_restart.png") as! CCSpriteFrame
        let restartHighlightedImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_restart_pressed.png") as! CCSpriteFrame
        let btnRestart:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: restartNormalImage, highlightedSpriteFrame: restartHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        btnRestart.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnRestart.position = ccp(0.25, 0.2)
        btnRestart.setTarget(self, selector: "btnRestartTapped")
        bg.addChild(btnRestart)
        
        let exitNormalImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_exit.png") as! CCSpriteFrame
        let exitHighlightedImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_exit_pressed.png") as! CCSpriteFrame
        let btnExit:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: exitNormalImage, highlightedSpriteFrame: exitHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        btnExit.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnExit.position = ccp(0.75, 0.2)
        btnExit.setTarget(self, selector: "btnExitTapped")
        bg.addChild(btnExit)
        
    }
    
    func btnRestartTapped() {
        let loadingScene:LoadingScene = LoadingScene()
        let transition:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(loadingScene, withTransition: transition)
    }
    
    func btnExitTapped() {
        let menuScene:MenuScene = MenuScene()
        let transition:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(menuScene, withTransition: transition)
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
}