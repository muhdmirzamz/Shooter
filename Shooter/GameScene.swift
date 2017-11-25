//
//  GameScene.swift
//  Shooter
//
//  Created by Muhd Mirza on 7/7/17.
//  Copyright © 2017 muhdmirzamz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var p = CGPoint.init(x: 100, y: 50)
	
	struct Collision {
		let None: UInt32 = 0
		let All: UInt32 = UInt32.max
		let Border: UInt32 = 1
		let Projectile: UInt32 = 2
		let Player: UInt32 = 3
		let Monster: UInt32 = 4
	}

	var playerSprite: SKSpriteNode?

    override func didMove(to view: SKView) {
		self.backgroundColor = SKColor.white
		
		self.physicsWorld.contactDelegate = self
		self.physicsWorld.gravity = .zero
		
		let border = SKPhysicsBody.init(edgeLoopFrom: self.frame)
		self.physicsBody = border
		self.physicsBody?.categoryBitMask = Collision().Border
		self.physicsBody?.collisionBitMask = Collision().Player
		
		self.playerSprite = SKSpriteNode.init(imageNamed: "player")
		self.playerSprite?.position = CGPoint.init(x: self.size.width / 5, y: self.size.height / 2)
		self.addChild(self.playerSprite!)
		
		self.playerSprite?.physicsBody = SKPhysicsBody.init(rectangleOf: (self.playerSprite?.size)!)
		self.playerSprite?.physicsBody?.categoryBitMask = Collision().Player
		self.playerSprite?.physicsBody?.collisionBitMask = Collision().Border
		self.playerSprite?.physicsBody?.isDynamic = false
		
		self.spawnMonster()
    }

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touchLocation = touches.first?.location(in: self)
		
		let touchThreshold = self.size.width / 2
		
		// player movement
		if (touchLocation?.x)! < touchThreshold {
			let actionMove = SKAction.move(to: touchLocation!, duration: 0.5)
			self.playerSprite?.run(actionMove)
		}
		
		// shooting
		if (touchLocation?.x)! > touchThreshold {
			let projectileSprite = SKSpriteNode.init(imageNamed: "projectile")
			projectileSprite.position = (self.playerSprite?.position)!
			self.addChild(projectileSprite)
			
			projectileSprite.physicsBody = SKPhysicsBody.init(circleOfRadius: projectileSprite.size.width / 2)
			projectileSprite.physicsBody?.categoryBitMask = Collision().Projectile
			projectileSprite.physicsBody?.contactTestBitMask = Collision().Monster
			
			let actionMove = SKAction.moveTo(x: self.size.width + 10, duration: 1)
			let actionMoveDone = SKAction.removeFromParent()
			projectileSprite.run(SKAction.sequence([actionMove, actionMoveDone]))
		}
	}
	
	public func didBegin(_ contact: SKPhysicsContact) {
		let projectileBody: SKPhysicsBody
		let monsterBody: SKPhysicsBody
		
		// find body type
		if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
			projectileBody = contact.bodyA
			monsterBody = contact.bodyB
		} else {
			projectileBody = contact.bodyB
			monsterBody = contact.bodyA
		}
		
		// type check just to make sure
		// not enough to merely check for collision value assigned
		if projectileBody.categoryBitMask == Collision().Projectile && monsterBody.categoryBitMask == Collision().Monster {
			let action = SKAction.removeFromParent()
			
			// access node to apply actions
			projectileBody.node?.run(action)
			monsterBody.node?.run(action)
			
			self.spawnMonster()
		}
	}
	
	func spawnMonster() {
		let monsterSprite = SKSpriteNode.init(imageNamed: "monster")
		monsterSprite.position = CGPoint.init(x: self.size.width - 100, y: self.randYPositionForMonsterWith(height: monsterSprite.size.height))
		self.addChild(monsterSprite)
		
		monsterSprite.physicsBody = SKPhysicsBody.init(rectangleOf: monsterSprite.size)
		monsterSprite.physicsBody?.categoryBitMask = Collision().Monster
		monsterSprite.physicsBody?.contactTestBitMask = Collision().Projectile

		let pointBlock = SKAction.run {
			self.p = self.randPositionFor(monsterSprite: monsterSprite)
		}
		
		// repeatForever is not dynamic
		// https://stackoverflow.com/a/34709183
		let actionMove = SKAction.run {
			monsterSprite.run(SKAction.move(to: self.p, duration: 2))
		}

		let sequence = SKAction.sequence([pointBlock, actionMove, SKAction.wait(forDuration: 1)])

		let forever = SKAction.repeatForever(sequence)
		monsterSprite.run(forever)
	}
	
	func randPositionFor(monsterSprite: SKSpriteNode) -> CGPoint {
	
		let randomHeightMax = CGFloat(arc4random_uniform(UInt32(self.size.height - monsterSprite.size.height)))
		let randomHeight = randomHeightMax + monsterSprite.size.height
		
		let randomWidthMax = CGFloat(arc4random_uniform(UInt32((self.size.width / 2) - monsterSprite.size.width)))
		let randomWidth = randomWidthMax + ((self.size.width / 2) + monsterSprite.size.width)
		
		print("In rand func \(randomWidth, randomHeight)")
		
		return CGPoint.init(x: randomWidth, y: randomHeight)
	}
	
	func randYPositionForMonsterWith(height: CGFloat) -> CGFloat {
		let random = CGFloat(arc4random_uniform(UInt32(self.size.height - height)))
		
		return random + height
	}
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
