//
//  AudioManager.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 5/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation


class AudioManager: NSObject {
    
    private var _soundEffects:NSArray = NSArray(array: ["arrow_shot.wav", "bird_hit.mp3", "lose.wav", "win.wav"]);
    
    private var _musicFiles:NSArray = NSArray(array: ["track_0", "track_1", "track_2", "track_3", "track_4", "track_5"]);
    
    private var _queuePlayer:AVQueuePlayer? = AVQueuePlayer()
    
    var _isSoundEnabled:Bool = true
    
    var _isMusicEnabled:Bool = true
    
    let  _kSoundKey:String = "AudioManager_Sound"
    
    let _kMusicKey:String = "AudioManager_Music"
    
    
    
    //private var _nextTrack:OALAudioTrack? = nil;
    
    func playMusic()  {
        if (!_isMusicEnabled) {
         return
        }
        _queuePlayer?.actionAtItemEnd = .None
        //1 check if the music is not already playing
        //if (_currentTrack == false) {
        //    NSLog("The music is already playing")
        //    return
        //}
        
        //2: getting random current track and next track
        let startTrackIndex = arc4random() % UInt32(_musicFiles.count)
        let nextTrackIndex = arc4random() % UInt32(_musicFiles.count)
        
        let startTrack: String = _musicFiles.objectAtIndex(Int(startTrackIndex)) as! String
        let nextTrack:String = _musicFiles.objectAtIndex(Int(nextTrackIndex)) as! String
        
        let item:AVPlayerItem = AVPlayerItem(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(startTrack, ofType: "mp3")!))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDidFinishPlaying", name: AVPlayerItemDidPlayToEndTimeNotification, object: _queuePlayer?.currentItem)
        _queuePlayer?.insertItem(item, afterItem: nil)
        
        
        _queuePlayer?.play()
        //3 Playing current track
       // _currentTrack? = OALAudioTrack.track() as! OALAudioTrack
       // _currentTrack?.delegate = self
       // _currentTrack?.preloadFile(startTrack)
       // _currentTrack?.play()
        
        //4
       // _nextTrack? = OALAudioTrack.track() as! OALAudioTrack
       // _nextTrack?.preloadFile(nextTrack)
        
        
    }
    
    func itemDidFinishPlaying() {
        NSLog("finished playing")
    }
    
    func preloadSoundEffects() {
        for item in _soundEffects {
            
            OALSimpleAudio.sharedInstance().preloadEffect(item as! String, reduceToMono: true, completionBlock: { (ALBuffer) in NSLog("Sound: %@ loaded", item as! String)})
            //OALSimpleAudio.sharedInstance().preloadEffect( item as! String, reduceToMono: true, completionBlock: nil)
            
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
       super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
    func nextTrack() {
        //1: Checking if the music wasn't stopped.
        //if (_currentTrack == false) {
        //   return
       // }
        
        //2: Next track becomes current track.
        //_currentTrack = _nextTrack
        //_currentTrack?.delegate = self
        //_currentTrack?.play()
        
        //3: Picking random next track and preloading
        //let nextTrackIndex:Int = Int(arc4random()) % _musicFiles.count
        //let nextTrack:String = _musicFiles.objectAtIndex(nextTrackIndex) as! String
        //_queuePlayer?.insertItem(AVPlayerItem(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(nextTrack, ofType: "mp3")!)), afterItem: nil)
        //_nextTrack = OALAudioTrack.track() as? OALAudioTrack
        //_nextTrack?.preloadFile(nextTrack)
        
        
    }
    
    func stopMusic() {
       _queuePlayer?.pause()
        _queuePlayer?.removeAllItems()
        //if (_currentTrack == false) {
        //    NSLog("The music is already stopped")
        //    return
       // }
        
        //_currentTrack?.stop()
        //_currentTrack = nil
        //_nextTrack = nil
    }
    
    func toggleSound() {
        _isSoundEnabled = !_isSoundEnabled
        NSUserDefaults.standardUserDefaults().setBool(_isSoundEnabled, forKey: _kSoundKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func toggleMusic() {
        _isMusicEnabled = !_isMusicEnabled
        if (!_isMusicEnabled) {
            self.stopMusic()
        }
        NSUserDefaults.standardUserDefaults().setBool(_isMusicEnabled, forKey: _kMusicKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    override init() {
        super.init(); //_currentTrack = NSArray();
        loadSettings()
    }
    
    func loadSettings() {
        //1
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        //2
        let audioDefaults:NSDictionary = [_kSoundKey: true, _kMusicKey: true]
        userDefaults.registerDefaults(audioDefaults as [NSObject : AnyObject])
        
        //3
        _isSoundEnabled = userDefaults.boolForKey(_kSoundKey)
        _isMusicEnabled = userDefaults.boolForKey(_kMusicKey)
        
        
        
    }
    
    
    
    class var sharedAudioManager: AudioManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AudioManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AudioManager()
        }
        return Static.instance!
    }
    
    
    func playSoundEffect(soundFile:String) {
        if (!_isSoundEnabled){
            return
        }
        OALSimpleAudio.sharedInstance().playEffect(soundFile)
    }
    
    func playSoundEffect(soundFile:String, withPosition pos:CGPoint) {
        if (!_isSoundEnabled){
            return
        }
        var pan = Float(pos.x/CCDirector.sharedDirector().viewSize().width)
        pan = clampf(pan, 0.0, 1.0)
        pan = pan * 2.0 - 1.0
        OALSimpleAudio.sharedInstance().playEffect(soundFile, volume: 1.0, pitch: 1.0, pan:pan, loop:false)
    }
    
    func playBackgroundSound(soundFile:String) {
        OALSimpleAudio.sharedInstance().playBg(soundFile, loop: true)    }
}

/*extension AudioManager : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        //println("finished playing \(flag)")
    //    dispatch_async(dispatch_get_main_queue(), { self.nextTrack()})
    }
    
   
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("\(error.localizedDescription)")
    }
    
}*/
