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
        let highscore:GameStats = HighscoreManager.sharedHighscoreManager._highScores![Int(index)]
        let playerName:String = highscore.playerName!
        let score = highscore.score
        
        //2
        let cell:CCTableViewCell = CCTableViewCell()
        cell.contentSizeType = CCSizeTypeMake(CCSizeUnit.Normalized, CCSizeUnit.Points)
        cell.contentSize = CGSizeMake(1, kHighscoreRowHeight)
        
        //3
        let bg:CCSprite = CCSprite.spriteWithImageNamed("table_cell_bg.png") as! CCSprite
        bg.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        bg.position = ccp(0.5, 0.5)
        cell.addChild(bg)
        
        //4
        let lblPlayerName:CCLabelTTF = CCLabelTTF.labelWithString(playerName, fontName: kHighscoreFontName, fontSize: CGFloat(kHighscoreFontSize)) as! CCLabelTTF
        lblPlayerName.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        lblPlayerName.position = ccp(0.05, 0.5)
        lblPlayerName.anchorPoint = ccp(0, 0.5)
        bg.addChild(lblPlayerName)
        
        //5
        let scoreString:String = String.init(format: "%d pts.", score!)
        let lblScore:CCLabelTTF = CCLabelTTF.labelWithString(scoreString, fontName: kHighscoreFontName, fontSize: CGFloat(kHighscoreFontSize)) as! CCLabelTTF
        lblScore.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        lblScore.position = ccp(0.95, 0.5)
        lblScore.anchorPoint = ccp(1, 0.5)
        bg.addChild(lblScore)
        return cell
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
        let backNormalImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_back.png")
        let backHighlightedImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_back_pressed.png")
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