//
//  GameScene.swift
//  this is circle tap
//
//  Created by Will Hodges on 10/25/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var level = 0
    var levelSelected = false
    var JSON = ""
    var levels: [LevelData]? = nil
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        
        do {
            let path = Bundle.main.path(forResource: "levels", ofType: "json")
            JSON = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            
        } catch {
            JSON = """
            [
                {
                    "name": "1",
                    "balls": [1,2,3],
                    "scales": [1.01, 1.05, 1.1],
                    "colors": ["black", "blue", "red"]
                }
            ]
            """
        }
        
        let jsonData = JSON.data(using: .utf8)!
        levels = try! JSONDecoder().decode([LevelData].self, from: jsonData)
        
        addLevelMenu()
    }
    
    func addLevelMenu() {
        
        let frameWidth = self.view!.frame.width
        let frameHeight = self.view!.frame.height
        
        // Prepare title node
        let label = SKLabelNode(text: "levels")
        label.fontColor = .black
        label.fontSize = 40
        label.position = CGPoint(x: frameWidth / 2, y: frameHeight - label.fontSize * 2)
        label.fontName = "Helvetica Neue"
        label.zPosition = 1
        label.name = "0"
    
        self.addChild(label)
        
        var increment: CGFloat = 1.0
        
        for level in levels! {
            // determine position
            let fontSize: CGFloat = 20.0
            let p = CGPoint(x: frameWidth / 2, y: frameHeight - label.fontSize * 2 - (fontSize * 2 * increment))
            // Add a label for each level
            let levelLabel = SKLabelNode(text: level.name)
            levelLabel.name = level.name
            levelLabel.fontName = "Helvetica Neue"
            levelLabel.fontSize = fontSize
            levelLabel.fontColor = .black
            levelLabel.position = p
            increment += 1
            
            self.addChild(levelLabel)
        }
    }
    
    func addLevel(levelName: String) {
        let frameWidth = self.view!.frame.width
        let frameHeight = self.view!.frame.height
        
        // Prepare title node
        let label = SKLabelNode(text: levelName)
        label.fontColor = .black
        label.fontSize = 40
        label.position = CGPoint(x: frameWidth / 2, y: frameHeight - label.fontSize * 2)
        label.fontName = "Helvetica Neue"
        label.zPosition = 1
        label.name = "0"
    
        self.addChild(label)
        
        let l = Int(levelName)!
        self.levelSelected = true
        self.level = l
        
        let level = self.levels![l - 1]
        
        
        for i in 0...(level.balls.count-1) {
            
            let color = getColor(named: level.colors[i])
            
            let ball: Ball = Ball(radius: CGFloat(level.sizes[i]), position: CGPoint(x: level.positions[i][0], y: level.positions[i][1]), color: color)
            ball.ball.name = String(level.scales[i])
            self.addChild(ball.ball)
                
        }
    }
    
    func getColor(named: String) -> SKColor {
        switch named {
            case "black":
                return SKColor.black
            case "red":
                return SKColor.red
            case "blue":
                return SKColor.blue
            case "green":
                return SKColor.green
            default:
                return SKColor.black
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.levelSelected {
            // If we're on the level menu,
            // We need to select a level
            for touch in touches {
                // Determine which level we've selected
                var level = "0"
                for child in self.children {
                    if child.contains(touch.location(in: self)) {
                        level = child.name!
                    }
                }
                
                // If we touched a level
                // And not the word "levels",
                // Clear the screen and add the level
                if level != "0" {
                    self.removeAllChildren()
                    addLevel(levelName: level)
                }
            }
        } else {
            // Otherwise, we need to deal with ball touches
            // Or go back to the level menu
            for touch in touches {
                var touchedList = [SKNode]()
                for child in self.children {
                    if child.contains(touch.location(in: self)) {
                        touchedList.append(child)
                    }
                }
                
                if touchedList.count != 0 {
                    // Touched node is the touched node
                    // Unless multiple touches, then
                    // Touched node is the back button
                    let touchedNode = touchedList.count == 1 ? touchedList[0] : touchedList.filter{
                        (item) -> Bool in
                        return item.name == "0"
                    }[0]
                    
                    if touchedNode.name == "0" {
                        // If we touched the level name,
                        // go back to the menu
                        self.removeAllChildren()
                        self.level = 0
                        self.levelSelected = false
                        addLevelMenu()
                    } else if touchedNode.name != "" {
                        let rate = CGFloat(Float(touchedNode.name!)!)
                        touchedNode.setScale(touchedNode.xScale * rate)
                        
                        let win = checkWin()
                        
                        if win {
                            self.removeAllChildren()
                            showWin()
                        }
                    }
                }
            }
        }
    }
    
    func showWin() {
        let frameWidth = self.view!.frame.width
        let frameHeight = self.view!.frame.height
        
        // Prepare title node
        let label = SKLabelNode(text: "you win!")
        label.fontColor = .black
        label.fontSize = 40
        label.position = CGPoint(x: frameWidth / 2, y: frameHeight / 2)
        label.fontName = "Helvetica Neue"
        label.zPosition = 1
        label.name = "0"
    
        self.addChild(label)
    }
    
    func checkWin() -> Bool {
        var sizes = [Double]()
        for child in self.children {
            if child.name != "0" {
                let area = child.frame.size.height
                sizes.append(Double(area))
            }
        }
        
        // MSE
        var s: Double = 0
        for size in sizes {
            s += pow(size, 2)
        }
        s /= Double(sizes.count)
        s = sqrt(s)
        
        var win = true
        for size in sizes {
            if size - s > 2 {
                win = false
            }
        }
        
        return win
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
