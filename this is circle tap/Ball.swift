//
//  Ball.swift
//  this is circle tap
//
//  Created by Will Hodges on 10/25/21.
//

import SpriteKit

class Ball {
    
    var ball: SKShapeNode
    
    init(radius: CGFloat, position: CGPoint, color: SKColor) {
        
        self.ball = SKShapeNode(circleOfRadius: radius)
        self.ball.position = position
        self.ball.strokeColor = color
        self.ball.fillColor = color
    }
}
