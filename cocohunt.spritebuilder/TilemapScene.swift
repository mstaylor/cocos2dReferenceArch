//
//  TilemapScene.swift
//  cocohunt
//
//  Created by Mills "Bud" Staylor on 11/13/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation

class TilemapScene : CCScene {
    enum NodeOrder : Int {
        case zOrderBackground
        case zOrderTilemap
        case zOrderObjects
    }
    
    private var _worldSize:Float? = nil
    
    private var _tileMap:CCTiledMap? = nil
    
    private var _bird:Bird? = nil
    
    private var _batchNode:CCSpriteBatchNode? = nil
    
    private var _parallaxNode:CCParallaxNode? = nil
    
    override init() {
        super.init();
    }
    
    override func onEnter() {
        super.onEnter()
        
        self.createBatchNode()
        self.addBackground()
        self.addTilemap()
        self.addBird()
    }
    
    private func createBatchNode() {
    CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("Cocohunt.plist")
        _batchNode = CCSpriteBatchNode(file: "Cocohunt.png")
        self.addChild(_batchNode, z: NodeOrder.zOrderObjects.rawValue)
        
    }
    
    private func addBackground() {
        let bg:CCSprite = CCSprite(imageNamed: "tile_level_bg.png")
        bg.positionType = CCPositionTypeNormalized
        bg.position = ccp(0.5, 0.5)
        self.addChild(bg, z: NodeOrder.zOrderBackground.rawValue)
    }
    
    private func addTilemap() {
        _tileMap = CCTiledMap(file: "tilemap.tmx")
        _worldSize = Float((_tileMap?.contentSizeInPoints.width)!)
        
        //1: Getting individual layers of the tile map
        let bushes:CCTiledMapLayer = (_tileMap?.layerNamed("Bushes"))!
        let trees:CCTiledMapLayer = (_tileMap?.layerNamed("Trees"))!
        let ground:CCTiledMapLayer = (_tileMap?.layerNamed("Ground"))!
        
        //2 Creating parallax node
        _parallaxNode = CCParallaxNode()
        
        //3: Removing layers from tile map, but not deallocating (passing no)
        bushes.removeFromParentAndCleanup(false)
        trees.removeFromParentAndCleanup(false)
        ground.removeFromParentAndCleanup(false)
        
        //4: Adding layers to parallax node using different parallaxRation
        _parallaxNode?.addChild(bushes, z: 0, parallaxRatio: ccp(0.2, 0), positionOffset: ccp(0,0))
        _parallaxNode?.addChild(trees, z: 1, parallaxRatio: ccp(0.5, 0), positionOffset: ccp(0,0))
        _parallaxNode?.addChild(ground, z: 2, parallaxRatio: ccp(1,0), positionOffset: ccp(0,0))
        
        //5: Adding parallax node to the scene
        self.addChild(_parallaxNode, z: NodeOrder.zOrderTilemap.rawValue)
    }
    
    private func addBird() {
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        _bird = Bird(birdType: Bird.BirdType.BirdTypeSmall)
        _bird?.flipX = true
        _bird?.position = ccp(viewSize.width * 0.2, viewSize.height * 0.2)
        _batchNode?.addChild(_bird)
    }
    
    override func update(dt: CCTime) {
        let distance = 150 * dt
        
        //var newTileMapPos:CGPoint = (_tileMap?.position)!
        //newTileMapPos.x = newTileMapPos.x - CGFloat(distance)
        
        var newPos = _parallaxNode?.position
        newPos?.x = (newPos?.x)! - CGFloat(distance)
        
        let viewSize:CGSize = CCDirector.sharedDirector().viewSize()
        let endX = -1 * CGFloat(_worldSize!) + viewSize.width
        
        if (newPos!.x > endX) {
            _parallaxNode?.position = newPos!
        }
        
        
    }

}
