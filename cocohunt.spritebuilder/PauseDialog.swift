//
//  PauseDialog.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 9/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class PauseDialog : CCNode {
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
        let closeNormalImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_close.png") as! CCSpriteFrame
        let closeHighlightedImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_close_pressed.png") as! CCSpriteFrame
        let btnClose:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: closeNormalImage, highlightedSpriteFrame: closeHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        btnClose.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnClose.position = ccp(1, 1)
        btnClose.setTarget(self, selector: "btnCloseTapped")
        bg.addChild(btnClose)
        
        //Restart button
        let restartNormalImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_restart_png") as! CCSpriteFrame
        let restartHighLightedImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_restart_pressed.png") as! CCSpriteFrame
        let btnRestart:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: restartNormalImage, highlightedSpriteFrame: restartHighLightedImage, disabledSpriteFrame: nil) as! CCButton
        btnRestart.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnRestart.position = ccp(0.25, 0.2)
        btnRestart.setTarget(self, selector: "btnRestartTapped")
        bg.addChild(btnRestart)
        
        
        
        
    }
}
