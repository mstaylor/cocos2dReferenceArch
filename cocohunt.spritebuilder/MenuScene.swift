//
//  MenuScene.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 8/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class MenuScene : CCScene {
    private var  _menu:CCLayoutBox? = CCLayoutBox()
    
    private var _btnSoundToggle:CCButton? = nil
    
    private var _btnMusicToggle:CCButton? = nil
    
    override init() {
        super.init();
        addBackground()
        addMenuButtons()
        addAudioButtons()
    }
    
    func addBackground() {
        let bg:CCSprite = CCSprite.spriteWithImageNamed("menu_bg.png") as! CCSprite
        
        bg.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        bg.position = ccp(0.5, 0.5)
        self.addChild(bg)
    }
    
    func addMenuButtons() {
        //1
        let startNormalImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_start.png")
        
        //2
        let startHighlightedImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_start_pressed.png")
        
        //3
        let btnStart:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: startNormalImage, highlightedSpriteFrame: startHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        
        //4
        btnStart.setTarget(self, selector: "btnStartTapped")
        
        let aboutNormalImage = CCSpriteFrame(imageNamed: "btn_about.png")
        let aboutHighlightedImage = CCSpriteFrame(imageNamed: "btn_about_pressed.png")
        let btnAbout:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: aboutNormalImage, highlightedSpriteFrame: aboutHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        
        btnAbout.setTarget(self, selector: "btnAboutTapped")
        
        let highscoresNormalImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_highscores.png")
        let highscoresHighlightedImage = CCSpriteFrame(imageNamed: "btn_highscores_pressed.png")
        
        let btnHighscores:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: highscoresNormalImage, highlightedSpriteFrame: highscoresHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        
        btnHighscores.setTarget(self, selector: "btnHighscoresTapped")
        
        //5
        _menu?.direction = CCLayoutBoxDirection.Vertical
        _menu?.spacing = 40.0
        
        //6
        _menu?.addChild(btnHighscores)
        _menu?.addChild(btnAbout)
        _menu?.addChild(btnStart)
        
        //7
        _menu?.layout()
        
        //8
        _menu?.anchorPoint = ccp(0.5, 0.5)
        _menu?.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        
        _menu?.position = ccp(0.5, 0.5)
        
        self.addChild(_menu!)
        
    }
    
    func addAudioButtons() {
        //1
        let soundOnImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_sound.png")
        let soundOffImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_sound_pressed.png")
        _btnSoundToggle = CCButton.buttonWithTitle(nil, spriteFrame: soundOnImage, highlightedSpriteFrame: soundOffImage, disabledSpriteFrame: nil) as?CCButton
        
        //2
        _btnSoundToggle?.togglesSelectedState = true
        
        //3
        _btnSoundToggle?.selected = AudioManager.sharedAudioManager._isSoundEnabled
        
        //4
        _btnSoundToggle?.block = {(AnyObject) in AudioManager.sharedAudioManager.toggleSound()}
        
        //5
        _btnSoundToggle?.positionType = CCPositionType( xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft )
        _btnSoundToggle?.position = ccp(0.95, 0.1)
        self.addChild(_btnSoundToggle!)
        
        //6
        let musicOnImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_music.png")
        let musicOffImage:CCSpriteFrame = CCSpriteFrame(imageNamed: "btn_music_pressed.png") 
        _btnMusicToggle = CCButton.buttonWithTitle(nil, spriteFrame: musicOnImage, highlightedSpriteFrame: musicOffImage, disabledSpriteFrame: nil) as? CCButton
        _btnMusicToggle?.togglesSelectedState = true
        _btnMusicToggle?.selected = AudioManager.sharedAudioManager._isMusicEnabled
        _btnMusicToggle?.block = {(AnyObject) in AudioManager.sharedAudioManager.toggleMusic()}
        
        //7
        let musicButtonOffset:Float = Float(_btnSoundToggle!.boundingBox().size.width) + 10
        let soundButtonPosInPoints:CGPoint = _btnSoundToggle!.positionInPoints
        _btnMusicToggle?.positionType = CCPositionTypeMake(CCPositionUnit.Points, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        _btnMusicToggle?.position = ccp(soundButtonPosInPoints.x - CGFloat(musicButtonOffset), 0.1)
        self.addChild(_btnMusicToggle!)
    }
    
    func btnStartTapped() {
        NSLog("Start tapped")
        //CCDirector.sharedDirector().replaceScene(GameScene())
        let levelSelectScene:LevelSelectScene = LevelSelectScene()
        let transition:CCTransition = CCTransition(pushWithDirection: CCTransitionDirection.Up, duration: 1.0)
        CCDirector.sharedDirector().replaceScene(levelSelectScene, withTransition: transition)
    }
    
    func btnAboutTapped() {
        NSLog("About tapped")
        let aboutScene:AboutScene = AboutScene()
        let aboutTransition:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().pushScene(aboutScene, withTransition: aboutTransition)
    }
    
    func btnHighscoresTapped() {
        NSLog("Highscores Tapped")
        let hsScene:HighScoresScene = HighScoresScene()
        let hsTransition:CCTransition = CCTransition(pushWithDirection: CCTransitionDirection.Down, duration: 1.0)
        CCDirector.sharedDirector().replaceScene(hsScene, withTransition: hsTransition)
    }
    
    
}