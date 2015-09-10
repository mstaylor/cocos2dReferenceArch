//
//  HUDLayer.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 3/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class HUDLayer : CCNode {
    
    let kFontName:String = "Noteworthy-Bold";
    let kFontSize:Int = 14;
    
    private var _score:CCLabelTTF! = nil;
    private var _birdsLeft:CCLabelTTF! = nil;
    private var _lives:CCLabelTTF! = nil;
    
    override init() {
        super.init();
        //1
        _score = CCLabelTTF.labelWithString("Score: 99999", fontName: kFontName, fontSize: CGFloat(kFontSize)) as! CCLabelTTF ;
        _birdsLeft = CCLabelTTF.labelWithString("Birds Left: 99", fontName: kFontName, fontSize: CGFloat(kFontSize)) as! CCLabelTTF;
        _lives = CCLabelTTF.labelWithString("Lives: 99", fontName: kFontName, fontSize: CGFloat(kFontSize)) as! CCLabelTTF;
        
        //2
        _score.color = CCColor(red: 0, green: 0.42, blue: 0.03);
        _birdsLeft.color = CCColor(red: 0.84, green: 0.49, blue: 0.08);
        _lives.color = CCColor(red: 0.64, green: 0.06, blue: 0.06);
        
        //3
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize();
        let labelsY = viewSize.height * 0.95;
        let labelsPaddingX = viewSize.width * 0.01;
        
        //4
        _score.anchorPoint = ccp(0, 0.5);
        _score.position = ccp(labelsPaddingX, labelsY);
        
        //5
        _birdsLeft.anchorPoint = ccp(0.5, 0.5);
        _birdsLeft.position = ccp(viewSize.width * 0.5, labelsY);
        
        //6
        _lives.anchorPoint = ccp(1, 0.5);
        _lives.position = ccp(viewSize.width - labelsPaddingX, labelsY);
        
        //7
        self.addChild(_score);
        self.addChild(_birdsLeft);
        self.addChild(_lives);
    }
    
    func updateStats(stats:GameStats?) {
        _score.string = String.localizedStringWithFormat("Score: %d", stats!.score!);
        _birdsLeft.string = String.localizedStringWithFormat("Birds Left: %d", stats!.birdsLeft!);
        _lives.string = String.localizedStringWithFormat("Lives: %d", stats!.lives!);
    }
    
}
