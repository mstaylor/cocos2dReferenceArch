//
//  GameStats.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 3/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameStats {
    
    var score:Int? = nil
    var birdsLeft:Int? = nil
    var lives:Int? = nil
    var timeSpent:Float? = nil
    
    init() {
        score = 0
        birdsLeft = 0
        lives = 0
        timeSpent = 0
    }
    
}
