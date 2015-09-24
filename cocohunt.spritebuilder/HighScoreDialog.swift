//
//  HighScoreDialog.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 9/23/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation

class HighScoreDialog: CCNode {

    var _currentStats:GameStats? = nil
    var _playerNameInput:CCTextField? = nil
    var _validateResult:CCLabelTTF? = nil
    
    var onCloseBlock:(()->Void)? = nil
    
    init(stats:GameStats) {
        super.init();
        _currentStats = stats
        createDialogLayout()
    }
    
    func createDialogLayout() {
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        let background:CCSprite = CCSprite.spriteWithImageNamed("highscore_dialog_bg.png") as! CCSprite
        background.position = ccp(viewSize.width * 0.5, viewSize.height * 0.5)
        self.addChild(background)
        
        let textFieldFrame:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("highscore_dialog_textfield.png") as! CCSpriteFrame
        _playerNameInput = CCTextField.init(spriteFrame: textFieldFrame)
        _playerNameInput?.string = "Player1"
        
        _playerNameInput?.preferredSize = textFieldFrame.rect.size
        _playerNameInput?.padding = 4.0
        _playerNameInput?.fontSize = 10.0
        
        _playerNameInput?.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        _playerNameInput?.anchorPoint = ccp(0.5, 0.5)
        _playerNameInput?.position = ccp(0.5, 0.7)
        background.addChild(_playerNameInput)
        
        _validateResult = CCLabelTTF.labelWithString("", fontName: "Helvetica", fontSize: 8) as? CCLabelTTF
        _validateResult?.color = CCColor.redColor()
        _validateResult?.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        _validateResult?.position = ccp(0.5, 0.6)
        background.addChild(_validateResult)
        
        let okNormalImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_ok.png") as! CCSpriteFrame
        let okHighlightedImage = CCSpriteFrame.frameWithImageNamed("btn_ok_pressed.png") as! CCSpriteFrame
        
        let btnOk:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: okNormalImage, highlightedSpriteFrame: okHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        btnOk.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnOk.position = ccp(0.5, 0.2)
        btnOk.setTarget(self, selector: "btnOkPressed")
        background.addChild(btnOk)
    }
    
    func btnOkPressed() {
        let playerName:String = (_playerNameInput?.string)!
        if (self.validatePlayerName(playerName)) {
            _currentStats?.playerName = playerName
            HighscoreManager.sharedHighscoreManager.addHighScore(_currentStats!)
            
            if (self.onCloseBlock != nil) {
                self.onCloseBlock?()
            }
            self.removeFromParentAndCleanup(true)
            
        }
    }
    
    func validatePlayerName(playerName:String)->Bool {
        let isEmpty = playerName.characters.count != 0
        if (!isEmpty) {
            _validateResult?.visible = true
            _validateResult?.string = "Plater name cannot be empty"
        } else {
            _validateResult?.visible = false
        }
        return isEmpty
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    
}
