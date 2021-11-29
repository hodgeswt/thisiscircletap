//
//  GameViewController.swift
//  this is circle tap
//
//  Created by Will Hodges on 10/25/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        let skView = view as! SKView
        skView.presentScene(GameScene(size: view.frame.size));
    }
}
