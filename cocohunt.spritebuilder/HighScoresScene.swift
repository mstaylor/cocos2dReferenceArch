//
//  HighScoresScene.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 9/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class HighScoresScene : CCScene, CCTableViewDataSource {
    
    let kHighscoreRowHeight = CGFloat(32)
    let kHighscoreFontName = "Helvetica"
    let kHighscoreFontSize = 12
    
    override init() {
        super.init();
        addBackground()
        addBackButton()
        addHighscoresTable()
    }
    
    func addHighscoresTable() {
        //1
        let highscoreTable:CCTableView = CCTableView()
        
        //2
        highscoreTable.rowHeight = kHighscoreRowHeight
        
        //3
        highscoreTable.anchorPoint = ccp(0.5, 1.0)
        
        //4
        highscoreTable.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        highscoreTable.position = ccp(0.5, 0.65)
        highscoreTable.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Normalized)
        highscoreTable.contentSize = CGSizeMake(1, 0.4)
        
        //5
        highscoreTable.userInteractionEnabled = false
        
        //6
        self.addChild(highscoreTable)
        
        //7
        highscoreTable.dataSource = self
        
        
    }
    
    func tableView(tableView: CCTableView!, nodeForRowAtIndex index: UInt) -> CCTableViewCell! {
       //1
       // let highscore =
        return nil
    }
    
    func tableViewNumberOfRows(tableView: CCTableView!) -> UInt {
       return UInt((HighscoreManager.sharedHighscoreManager._highScores?.count)!)
    }
    
    func addBackground() {
        let bg:CCSprite = CCSprite.spriteWithImageNamed("highscores_bg.png") as! CCSprite
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
        let transition:CCTransition = CCTransition(pushWithDirection: CCTransitionDirection.Up, duration: 1.0)
        let scene:MenuScene = MenuScene()
        CCDirector.sharedDirector().replaceScene(scene, withTransition: transition)
        
    }
    
    
    
}