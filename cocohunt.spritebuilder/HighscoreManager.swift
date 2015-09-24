//
//  HighscoreManager.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 9/21/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation

class HighscoreManager: NSObject {
    let kMaxHighscores = 5
    
    var _highScores:[GameStats]? = nil
    
    override init() {
        super.init();
        _highScores = [GameStats]()
    }
    
    func isHighscore(score:Int)->Bool {
        return (score > 0) && ((_highScores?.count < kMaxHighscores) || (score > _highScores?[(_highScores?.count)!-1].score))
    }
    
    func addHighScore(newHighscore:GameStats) {
        assert(newHighscore.playerName!.characters.count > 0, "You must specify player name for the highscore!")
        
        //Searching for a place to insert highscore.
        for var i = 0; i < _highScores?.count; i++ {
            let gs = _highScores?[i]
            if (newHighscore.score > gs?.score) {
                _highScores? += [newHighscore]
                
                if (_highScores?.count > kMaxHighscores) {
                    _highScores?.removeLast()
                }
                return
            }
        }
        
        //We can get here if only if newHighscore is not higher than any score in highscores table
        //then there is only 1 chance we add it to the table, if it is still not full (<5 highscores on record)
        if (_highScores?.count < kMaxHighscores) {
            _highScores? += [newHighscore]
            return
        }
    }
    
    class var sharedHighscoreManager: HighscoreManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: HighscoreManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = HighscoreManager()
        }
        return Static.instance!
    }
    
}
