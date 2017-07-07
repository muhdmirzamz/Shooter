//
//  GameScene.swift
//  Shooter
//
//  Created by Muhd Mirza on 7/7/17.
//  Copyright © 2017 muhdmirzamz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

	var playerSprite: SKSpriteNode?

    override func didMove(to view: SKView) {
		self.backgroundColor = SKColor.white
		
		self.playerSprite = SKSpriteNode.init(imageNamed: "player")
		self.playerSprite?.position = CGPoint.init(x: self.size.width / 4, y: self.size.height / 2)
		self.addChild(self.playerSprite!)
    }
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
