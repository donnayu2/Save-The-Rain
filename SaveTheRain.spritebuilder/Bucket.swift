//
//  Bucket.swift
//  SaveTheRain
//
//  Created by donna yu on 8/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Bucket: CCSprite {
    
//    var isTouchingBucket = false
//    
//    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
//        /* Called when a touch begins */
//        
//        var touch = touches.anyObject() as UITouch!
//        var location = touch.locationInNode(self)
//        
//        if let body = self.physicsWorld.bodyAtPoint(location) {
//            if body.node!.name == "Bucket" {
//                istouchingBucket = true
//            }
//        }
//    }
//    
//    override func touchMoved(touches: CCTouch!, withEvent event: CCTouchEvent!) {
//        if isTouchingBucket {
//            var touch = touches.anyObject() as UITouch!
//            var location = touch.locationInNode(self)
//            var prevLocation = touch.previousLocationInNode(self)
//            
//            var bucket = childNodeWithName("bucket") as! SKSpriteNode
//            
//            var xPos = bucket.position.x + (location.x - prevLocation.x)
//            
//            xPos = max(xPos, bucket.size.width / 2)
//            xPos = min(xPos, size.width - bucket.size.width / 2)
//            
//            bucket.position = CGPointMake(xPos, bucket.position.y)
//        }
//    }
}