//
//  GameScene.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 3/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import CoreMotion

class GameScene : CCScene {
    
    
    private var _hunter: Hunter? = nil;
    
    //private var _bird: Bird? = nil;
    
    private var _timeUntilNextBird:Double? = nil;
    
    private var _birds:NSMutableArray? = nil;
    
    private var _arrows:NSMutableArray? = nil;
    
    private var gameState:GameState? = nil;
    
    private var _birdsToSpawn:Int? = nil;
    
    private var _birdsToLose:Int? = nil;
    
    private var _maxAimingRadius:Int? = nil;
    
    private var _aimingIndicator:CCSprite? = nil;
    
    private var _useGyroToAim:Bool? = nil;
    
    private var _motionManager:CMMotionManager? = nil;
    
    private var _hud:HUDLayer? = nil;
    
    private var _gameStats:GameStats? = nil;
    
    private var _batchNode:CCSprite? = nil;
    
    enum GameState {
        case GameStateUnitialized
        case GameStatePlaying
        case GameStatePaused
        case GameStateWon
        case GameStateLost
    }
    
    enum NodeOrder : Int {
        case Z_BACKGROUND
        case Z_BATCH_NODE
        case Z_LABELS
        case Z_HUD
        case Z_PAUSE_BUTTON
        case Z_DIALOGS
    }
    
    
    
    //private var _batchNode: CCNode? = nil;
    override init() {
        super.init();
        gameState = GameState.GameStateUnitialized;
        _useGyroToAim = false;
        _birdsToSpawn = 10;
        _birdsToLose = 1;
        
        _timeUntilNextBird = -1;
        _birds = NSMutableArray();
        _arrows = NSMutableArray();
        createBatchNode();
        addBackground();
        addHunter();
        setupAimingIndicator();
        //addBird();
        userInteractionEnabled = true;
        initializeHUD();
        initializeStats();
        self.addPauseButton()
        
    }
    
    private func startFire() {
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
        //1: Adding stone and wood image as a base for fire particle system
        let campfire:CCSprite = CCSprite.spriteWithImageNamed("campfire.png") as! CCSprite
        campfire.position = ccp(viewSize.width * 0.5, viewSize.height * 0.05)
        self.addChild(campfire);
        
        //2 Calculating the point where the fire starts
        let campFireTop:CGPoint = ccp(campfire.position.x, campfire.position.y + campfire.boundingBox().size.height * 0.5)
        
        //3 Creating predefined particle system and placing it at the top of the campfire sprite
        let fire:CCParticleFire = CCParticleFire.particleWithTotalParticles(300) as! CCParticleFire
        fire.position = campFireTop
        
        //4: Re-using feather texture as fire particle
        fire.texture = CCTexture(file: "feather.png")
        
        //5: scaling it down a bit, since by default it is too big
        fire.scale = 0.3
        
        self.addChild(fire)
        
        
        
    }
    
    private func createTheSun() {
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
        let sun:CCParticleSystem = CCParticleSystem(file: "sun.plist")
        sun.position = ccp(viewSize.width * 0.05, viewSize.height * 0.9)
        self.addChild(sun)
        
    }
    
    private func initializeHUD() {
        _hud = HUDLayer();
        self.addChild(_hud, z:NodeOrder.Z_HUD.rawValue);
    }
    
    private func initializeStats() {
        _gameStats = GameStats();
        _gameStats?.birdsLeft = _birdsToSpawn;
        _gameStats?.lives = _birdsToLose;
        _hud?.updateStats(_gameStats);
    }
    
    private func initializeControls() {
        if (_useGyroToAim!) {
            _motionManager = CMMotionManager();
            _motionManager?.deviceMotionUpdateInterval = 1.0/6.0;
            _motionManager?.startDeviceMotionUpdates();
        }
    }
    
    override func onEnter() {
        super.onEnter();
        self.gameState = GameState.GameStatePlaying;
        initializeControls();
        self.startFire()
        AudioManager.sharedAudioManager.playMusic()
        //self.createTheSun()
    }
    
    override func onExit() {
        super.onExit()
        AudioManager.sharedAudioManager.stopMusic()
    }
    
    private func setupAimingIndicator() {
        let aimingIndicator:CCSprite = CCSprite.spriteWithImageNamed("power_meter.png") as! CCSprite;
        //1
        _maxAimingRadius = 100;
        
        
        //2
        aimingIndicator.opacity = 0.3;
        aimingIndicator.anchorPoint = ccp(0, 0.5);
        aimingIndicator.visible = false;
        
        //3
        //addChild(aimingIndicator);
        _batchNode?.addChild(aimingIndicator);
        self._aimingIndicator = aimingIndicator;
    }
    
    private func createBatchNode() {
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("Cocohunt.plist")
        _batchNode = CCSprite();
        self.addChild(_batchNode, z: NodeOrder.Z_BATCH_NODE.rawValue);
        //_batchNode = CCSprite(imageNamed: "Cocohunt.png")
        //self.addChild(_batchNode, z: 1)
    }
    
    private func addHunter() {
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
        _hunter = Hunter();
        let hunterPositionX = viewSize.width*0.5 - 180.0;
        let hunterPositionY = viewSize.height*0.3;
        _hunter?.position = ccp(hunterPositionX, hunterPositionY);
        _batchNode?.addChild(_hunter!);
        
        
    }
    
    //private func addBird() {
    //    let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
    //    _bird = Bird(birdType: Bird.BirdType.BirdTypeSmall);
    //    _bird?.position = ccp(viewSize.width * 0.5, viewSize.height * 0.9);
    //    self.addChild(_bird);
        
    //}
    
    private func addBackground() {
        let viewSize: CGSize = CCDirector.sharedDirector().viewSize();
        let background:CCSprite = CCSprite.spriteWithImageNamed("game_scene_bg.png") as! CCSprite;
        
        background.position = ccp(viewSize.width * 0.5, viewSize.height * 0.5);
        self.addChild(background, z:NodeOrder.Z_BACKGROUND.rawValue);
    }
    
    override func update(delta: CCTime) {
        
        if (self.gameState != GameState.GameStatePlaying) {
            _gameStats?.timeSpent! += Float(delta)
            return;
        }

        //Updating gyro aim (if its enabled)
        self.updateGyroAim();
        //1
        _timeUntilNextBird = _timeUntilNextBird! -  delta;
        
        //2
        if (_timeUntilNextBird <= 0 && _birdsToSpawn > 0) {
            //3
            self.spawnBird();
            _birdsToSpawn!--;
            
            let nextBirdTimeMax:Int = 3;
            let nextBirdTimeMin:Int = 1;
            let nextBirdTime = nextBirdTimeMin + Int(arc4random_uniform(UInt32(nextBirdTimeMax) - UInt32(nextBirdTimeMin)));
            _timeUntilNextBird = Double(nextBirdTime);
            _gameStats?.birdsLeft = _birdsToSpawn;
            _hud?.updateStats(_gameStats);
        }
        
        //1
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
        let viewBounds:CGRect = CGRectMake(0, 0, viewSize.width, viewSize.height);
        
        //2
        
        for var i = _birds!.count - 1; i >= 0; i-- {
            let bird:Bird = _birds!.objectAtIndex(i) as! Bird;
            
            //3
            let birdFlewOffScreen:Bool = (bird.position.x + (bird.contentSize.width * 0.5)) > viewSize.width;
            
            //4
            if (bird.birdState == Bird.BirdState.BirdStateFlyingOut  && birdFlewOffScreen) {
                _birdsToLose!--;
                
                _gameStats?.lives = _birdsToLose;
                _hud?.updateStats(_gameStats);
                
                bird.removeBird(false);
                _birds?.removeObject(bird);
                continue;
            }
            
            for var j = _arrows!.count - 1; j >= 0;  j-- {
                let arrow:CCSprite = _arrows!.objectAtIndex(j) as! CCSprite;
                
                //6
                if (!CGRectContainsPoint(viewBounds, arrow.position)) {
                    arrow.removeFromParentAndCleanup(true);
                    _arrows?.removeObject(arrow);
                    continue;
                }
                
                //7
                if (CGRectIntersectsRect(arrow.boundingBox(), bird.boundingBox())) {
                    arrow.removeFromParentAndCleanup(true);
                    _arrows?.removeObject(arrow);
                    let score:Int = bird.removeBird(true);
                    bird.removeBird(true);
                    _birds?.removeObject(bird);
                    
                    _gameStats!.score! += score;
                    _hud?.updateStats(_gameStats);
                    break;
                }
            }
            
            
        }
        
        self.checkWonLost();
        
    }
    
    private func checkWonLost() {
        if (_birdsToLose <= 0) {
            self.lost();
        } else if(_birdsToSpawn <= 0 && _birds?.count <= 0) {
            self.won();
        }
    }
    
    private func lost() {
        AudioManager.sharedAudioManager.playSoundEffect("lose.wav")
        self.gameState = GameState.GameStateLost;
        self.displayWinLoseLabelWithText("You Lose!", fontFileName: "lost.fnt");
        //NSLog("YOU LOST!");
    }
    
    private func won() {
        AudioManager.sharedAudioManager.playSoundEffect("win.wav")
        self.gameState = GameState.GameStateWon;
        self.displayWinLoseLabelWithText("You Win!", fontFileName: "win.fnt");
        //NSLog("YOU WON!");
    }
    
    private func displayWinLoseLabelWithText(text:String?, fontFileName:String?) {
        //Creating label and its final position
        
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
        let label:CCLabelBMFont = CCLabelBMFont.labelWithString(text, fntFile: fontFileName) as! CCLabelBMFont;
        label.position = ccp(viewSize.width * 0.5, viewSize.height * 0.75);
        self.addChild(label, z: NodeOrder.Z_LABELS.rawValue);
        
        //setting initial scale to almost invisible (the label will pop out)
        label.scale = 0.01;
        
        //creating eased action to scale label out to 1.5x scale
        let scaleUp:CCActionScaleTo = CCActionScaleTo.actionWithDuration(1.5, scale: 1.2) as! CCActionScaleTo;
        let easedScaleUp:CCActionEaseIn = CCActionEaseIn.actionWithAction(scaleUp, rate: 5.0) as! CCActionEaseIn;
        
        //...and then to final 1.0x scale (this will create a required effect)
        let scaleNormal:CCActionScaleTo = CCActionScaleTo.actionWithDuration(0.5, scale: 1.0) as! CCActionScaleTo;
        
        //Creating sequence for the label and running it
        let scaleUpTheNormal:CCActionSequence = CCActionSequence.actionWithArray([easedScaleUp, scaleNormal]) as! CCActionSequence;
        label.runAction(scaleUpTheNormal);
        
    }
    
    private func spawnBird() {

        let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
        let maxY = UInt32(viewSize.height * 0.9);
        let minY = UInt32(viewSize.height * 0.6);
        let birdY = minY + arc4random_uniform(maxY - minY);
        let birdX = UInt32(viewSize.width * 1.3);
        let birdStart:CGPoint = ccp(CGFloat(birdX), CGFloat(birdY));
        let birdType:Bird.BirdType = Bird.BirdType(rawValue:Int(arc4random_uniform(3)))!;
        let bird:Bird = Bird(birdType: birdType);
        bird.position = birdStart;
        _batchNode?.addChild(bird);
        _birds!.addObject(bird);
        let maxTime:UInt32 = 20;
        let minTime:UInt32 = 10;
        let random:UInt32 = arc4random();
        let birdTime = minTime + (random % (maxTime - minTime));
        let screenLeft:CGPoint = ccp(0, CGFloat(birdY));
        
        let moveToLeftEdge:CCActionMoveTo! = CCActionMoveTo.actionWithDuration(CCTime(birdTime), position: screenLeft) as! CCActionMoveTo;
        
        //1
        let turnaround:CCActionCallFunc! = CCActionCallFunc.actionWithTarget(bird, selector: "turnaround") as! CCActionCallFunc;
        
        let moveBackOffScreen:CCActionMoveTo! = CCActionMoveTo.actionWithDuration(CCTime(birdTime), position: birdStart) as! CCActionMoveTo;
        
        //2
        let moveLeftThenBack:CCActionSequence! = CCActionSequence.actionWithArray([moveToLeftEdge, turnaround, moveBackOffScreen, turnaround]) as! CCActionSequence;
        
        //3
        let flyForever:CCActionRepeatForever! = CCActionRepeatForever.actionWithAction(moveLeftThenBack) as! CCActionRepeatForever;
        
        bird.runAction(flyForever);
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        //If not in Playing state, not handling this touch.
        if (gameState != GameState.GameStatePlaying) {
            super.touchBegan(touch, withEvent: event);
        }
        
        if (_useGyroToAim!) {
            //if using gyro, then checking if hunter is not reloading since it is always aiming
            if (_hunter?.hunterState != Hunter.HunterState.HunterStateReloading) {
                //if valid state, shooting straight away (not in touchEnded)
                let targetPoint:CGPoint = self.getGyroTargetPoint()!;
                let arrow:CCSprite = _hunter!.shootAtPoint(targetPoint)!;
                _arrows?.addObject(arrow);
            }
            
            super.touchBegan(touch, withEvent: event);
        } else {
            //In case using touches the only state we can start aiming is Idle
            if (_hunter?.hunterState != Hunter.HunterState.HunterStateIdle) {
                super.touchBegan(touch, withEvent: event);
            }
            
            let touchLocation:CGPoint = touch.locationInNode(self);
            _hunter?.aimAtPoint(touchLocation);
            
            _aimingIndicator?.visible = true;
            self.checkAimingIndicatorForPoint(touchLocation);
        }
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocation:CGPoint = touch.locationInNode(self);
        _hunter?.aimAtPoint(touchLocation);
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (self.gameState != GameState.GameStatePlaying) {
            return;
        }
        let touchLocation:CGPoint = touch.locationInNode(self);
        let canShoot:Bool = self.checkAimingIndicatorForPoint(touch.locationInNode(self));
        if (canShoot) {
            let arrow:CCSprite! = _hunter!.shootAtPoint(touchLocation);
            _arrows?.addObject(arrow);
        } else {
            _hunter?.getReadyToShootAgain();
        }
        _aimingIndicator?.visible = false;
    }
    
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        _hunter?.getReadyToShootAgain();
    }
    
    private func checkAimingIndicatorForPoint(point: CGPoint?) -> Bool {
        //1
        _aimingIndicator!.position = _hunter!.torsoCenterInWorldCoordinates()!;
        _aimingIndicator!.rotation = _hunter!.torsoRotation();
        
        //2
        let distance = ccpDistance(_aimingIndicator!.position, point!);
        let isInRange:Bool = distance < CGFloat(_maxAimingRadius!);
        
        //3
        let scale = distance/_aimingIndicator!.contentSize.width;
        _aimingIndicator!.scale = Float(scale);
        
        //4
        _aimingIndicator!.color = isInRange ? CCColor.greenColor() : CCColor.redColor();
        
        //5
        return isInRange;
    }
    
    private func getGyroTargetPoint() -> CGPoint?{
        //getting gyro data.
        let motion:CMDeviceMotion? = _motionManager?.deviceMotion;
        let attitude:CMAttitude? = motion!.attitude;
        
        //use pitch to aim
        var pitch:Double? = attitude!.roll;
        
        //Using roll to detect which side of the iPhone is up
        //(home button on the left or right)
        let roll:Double? = attitude!.roll;
        if (roll > 0) {
            pitch = -1 * pitch!;
        }
        
        let forward:CGPoint = ccp(1.0, 0);
        let rot:CGPoint = ccpRotateByAngle(forward, CGPointZero, Float(pitch!));
        let targetPoint:CGPoint = ccpAdd(_hunter!.torsoCenterInWorldCoordinates()!, rot);
        
        return targetPoint;
    }
    
    private func updateGyroAim() {
        if (!_useGyroToAim!) {
            return;
        }
        let targetPoint:CGPoint? = self.getGyroTargetPoint();
        _hunter?.aimAtPoint(targetPoint!);
    }
    
    private func addPauseButton() {
        let pauseNormalImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_pause.png") as! CCSpriteFrame
        let pauseHighlightedImage:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("btn_pause_pressed.png") as! CCSpriteFrame
        let btnPause:CCButton = CCButton.buttonWithTitle(nil, spriteFrame: pauseNormalImage, highlightedSpriteFrame: pauseHighlightedImage, disabledSpriteFrame: nil) as! CCButton
        btnPause.positionType = CCPositionTypeMake(CCPositionUnit.Normalized, CCPositionUnit.Normalized, CCPositionReferenceCorner.BottomLeft)
        btnPause.position = ccp(0.95, 0.5)
        btnPause.setTarget(self, selector: "btnPauseTapped")
        self.addChild(btnPause, z: NodeOrder.Z_PAUSE_BUTTON.rawValue)
        
    }
    
    func btnPauseTapped() {
        if (gameState != GameState.GameStatePlaying) {
            return
        }
        gameState = GameState.GameStatePaused
        
        for bird in _birds! {
           (bird as! Bird).paused = true
        }
        
        for arrow in _arrows!{
            (arrow as! CCSprite).paused = true
        }
        
        let dlg:PauseDialog = PauseDialog()
        dlg.onCloseBlock = {
            Void in
            self.gameState = GameState.GameStatePlaying
            for bird in self._birds! {
                (bird as! Bird).paused = false
            }
            for arrow in self._arrows! {
                (arrow as! CCSprite).paused = false
            }
            
        }
        self.addChild(dlg, z: NodeOrder.Z_DIALOGS.rawValue)
        
    }
    
}

