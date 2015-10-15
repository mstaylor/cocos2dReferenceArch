//
//  PauseDialog.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 9/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class PauseDialog : CCNode, UIAlertViewDelegate {
    
    var onCloseBlock:(()->Void)? = nil
    
    
    override init() {
        super.init();
        setupModalDialog()
        createDialogLayout()
    }
    
    func setupModalDialog() {
        self.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Normalized)
        self.contentSize = CGSizeMake(1, 1)
        self.userInteractionEnabled = true

    }
    
    func createDialogLayout() {
        let bg:CCSprite = CCSprite.spriteWithImageNamed("pause_dialog_bg.png") as! CCSprite
        bg.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        bg.position = ccp(0.5, 0.5)
        self.addChild(bg)
        
        //Close button (X)
        let closeNormalImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_close.png")
        let closeHighlightedImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_close_pressed.png")
        let btnClose:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: closeNormalImage, highlightedSpriteFrame: closeHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        btnClose.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnClose.position = ccp(1, 1)
        btnClose.setTarget(self, selector: "btnCloseTapped")
        bg.addChild(btnClose)
        
        //Restart button
        let restartNormalImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_restart.png")
        let restartHighLightedImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_restart_pressed.png")
        let btnRestart:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: restartNormalImage, highlightedSpriteFrame: restartHighLightedImage, disabledSpriteFrame: nil) as! CCButton
        btnRestart.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnRestart.position = ccp(0.25, 0.2)
        btnRestart.setTarget(self, selector: "btnRestartTapped")
        bg.addChild(btnRestart)
        
        let exitNormalImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_exit.png")
        let exitHighLightedImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_exit_pressed.png") 
        let btnExit:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: exitNormalImage, highlightedSpriteFrame: exitHighLightedImage, disabledSpriteFrame: nil) as! CCButton
        
        btnExit.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnExit.position = ccp(0.75, 0.2)
        btnExit.setTarget(self, selector: "btnExitTapped")
        bg.addChild(btnExit)
    }
    
    
    func btnCloseTapped() {
        self.onCloseBlock?()
        self.removeFromParentAndCleanup(true)
    }
    
    func btnRestartTapped() {
        NSLog("Restart")
        let loadingScene:LoadingScene = LoadingScene()
        let transition:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(loadingScene, withTransition: transition)
    }
    
    func btnExitTapped() {
        NSLog("Exit")
        let alert:UIAlertView = UIAlertView(title: "Exit confirmation", message: "Are you sure?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "yes")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1) {
            let menuScene:MenuScene = MenuScene()
            let transition:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
            CCDirector.sharedDirector().replaceScene(menuScene, withTransition: transition)
        }
    }
    
    //override func clickedB
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        NSLog("Touch swallowed by the pause dialog")
    }
}
