//
//  RainDrop.swift
//  SaveTheRain
//
//  Created by donna yu on 8/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class RainDrop: CCSprite {
    weak var rainDrop: CCSprite!
    
    let carrotDistance : CGFloat = 142
    
    func setupRandomPosition() {
        let randomPrecision : UInt32 = 100
        let random = CGFloat(arc4random_uniform(randomPrecision)) / CGFloat(randomPrecision)
        let range = rainDropMaximumPositionY - rainDropDistance - rainDropMinimumPositionY
        rainDrop.position = ccp(rainDrop.position.x, rainDropMinimumPositionY + (random * range));
        rainDrop.position = ccp(bottomCarrot.position.x, topCarrot.position.y + carrotDistance);
    }
}
//    func didLoadFromCCB() {
//        for i in 0..<10 {
//            var piece = CCBReader.load("RainDrop") as! Piece
//            
//            var yPos = piece.contentSizeInPoints.height * CGFloat(i)
//            piece.position = CGPoint(x: 0, y: yPos)
//            piecesNode.addChild(piece)
//            pieces.append(piece)
//        }
//          userInteractionEnabled = true
//    }
//}