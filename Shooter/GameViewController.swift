//
//  GameViewController.swift
//  Shooter
//
//  Created by Muhd Mirza on 7/7/17.
//  Copyright © 2017 muhdmirzamz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let gameScene = GameScene.init(size: self.view.frame.size)
		gameScene.scaleMode = .resizeFill
		
		let skScene = self.view as! SKView
		skScene.ignoresSiblingOrder = true

		skScene.presentScene(gameScene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
