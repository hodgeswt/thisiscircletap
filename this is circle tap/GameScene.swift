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
    var highestLevel = 1
        
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        
        run(Sounds.c1)
        
        do {
            let path = Bundle.main.path(forResource: "levels", ofType: "json")
            JSON = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            
        } catch {
            JSON = """
            [
                {
                    "name": "1",
                    "balls": [1,2,3],
                    "scales": [1.03, 1.05, 0.95],
                    "colors": ["black", "blue", "red"],
                    "positions": [
                        [100, 400],
                        [200, 500],
                        [300, 600],
                    ],
                    "sizes": [50, 70, 107]
                }
            ]
            """
        }
        
        let jsonData = JSON.data(using: .utf8)!
        levels = try! JSONDecoder().decode([LevelData].self, from: jsonData)
        
        addLevelMenu()
    }
    
    func addLevelMenu() {
        
        let defaults = UserDefaults.standard
        if let storedValue = defaults.string(forKey: "highestLevel") {
            // If there is a stored value, get it
            self.highestLevel = Int(storedValue)!
        } else {
            // If there's no stored value, set it
            defaults.set("1", forKey: "highestLevel")
        }
        
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
        
        let instructions = SKLabelNode(text: "instructions")
        instructions.fontColor = .black
        instructions.fontSize = 20
        instructions.position = CGPoint(x: frameWidth / 2, y: frameHeight - instructions.fontSize * 5)
        instructions.fontName = "Helvetica Neue"
        instructions.zPosition = 1
        instructions.name = "instructions"
    
        self.addChild(instructions)
        
        var increment: CGFloat = 1.0
        
        for level in levels! {
            // determine position
            let fontSize: CGFloat = 20.0
            let p = CGPoint(x: frameWidth / 2, y: frameHeight - label.fontSize * 2 - (fontSize * 2 * increment))
            // Add a label for each level
            let levelLabel = SKLabelNode(text: level.name)
            if Int(level.name)! > self.highestLevel {
                // If we haven't unlocked this level yet,
                // Gray it out and make it unclickable
                levelLabel.name = "0"
                levelLabel.fontColor = .gray
            } else {
                levelLabel.name = level.name
                levelLabel.fontColor = .black
            }
            levelLabel.fontName = "Helvetica Neue"
            levelLabel.fontSize = fontSize
            levelLabel.position = p
            increment += 1
            
            self.addChild(levelLabel)
        }
        
        let resetButton = SKLabelNode(text: "reset progress")
        resetButton.fontColor = .black
        resetButton.fontSize = 20
        resetButton.position = CGPoint(x: frameWidth / 2, y: resetButton.frame.height * 2)
        resetButton.fontName = "Helvetica Neue"
        resetButton.zPosition = 1
        resetButton.name = "reset"
        
        self.addChild(resetButton)
        
        let gameTitle = SKLabelNode(text: "this is circle tap")
        gameTitle.fontColor = .black
        gameTitle.fontSize = 10
        gameTitle.position = CGPoint(x: frameWidth / 2, y: resetButton.frame.height * 2 + gameTitle.frame.height * 2)
        gameTitle.fontName = "Helvetica Neue"
        gameTitle.zPosition = 1
        gameTitle.name = "0"
        
        self.addChild(gameTitle)
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
        
        addSizeLabel(text: createSizeLabelContent())
    }
    
    func showInstructions() {
        let frameWidth = self.view!.frame.width
        let frameHeight = self.view!.frame.height
        
        let label = SKLabelNode(text: "instructions")
        label.fontColor = .black
        label.fontSize = 40
        label.position = CGPoint(x: frameWidth / 2, y: frameHeight - label.fontSize * 2)
        label.fontName = "Helvetica Neue"
        label.zPosition = 1
        label.name = "0"
    
        self.addChild(label)
        
        let instructionsText = """
        tap the circles to change their size.
        continue tapping until they're all within
        two size points of each other.
        
        tap the level name to go back.
        tap 'instructions' above to go back.
        """
        let instructions = SKLabelNode(text: instructionsText)
        instructions.fontColor = SKColor.black
        instructions.fontSize = 20
        instructions.numberOfLines = 0
        instructions.position = CGPoint(x: frameWidth / 2, y: frameHeight - instructions.frame.height - 100)
        instructions.fontName = "Helvetica Neue"
        instructions.zPosition = 1
        instructions.name = "0"
    
        self.addChild(instructions)
    }
    
    func addSizeLabel(text: String) {
        let frameHeight = self.view!.frame.height
        
        let ballLabel = SKLabelNode(text: text)
        ballLabel.numberOfLines = 0
        let ballLabelFontSize: CGFloat = 20
        ballLabel.fontSize = ballLabelFontSize
        ballLabel.fontName = "Helvetica Neue"
        ballLabel.fontColor = SKColor.black
        ballLabel.position = CGPoint(x: 75, y: frameHeight - ballLabel.frame.height * 2)
        ballLabel.zPosition = 1
        ballLabel.name = ""
        self.addChild(ballLabel)
    }
    
    func createSizeLabelContent() -> String {
        var balls = [SKNode]()
        for child in self.children {
            if child.name != "" && child.name != "0" {
                balls.append(child)
            }
        }
        
        var labelText = ""
        
        for ball in balls {
            let l = self.levels![self.level - 1]
            let index: Int = l.scales.firstIndex(of: Float(ball.name!)!)!
            let color = l.colors[index]
            labelText += color + ": " + String(Int(ball.frame.size.height)) + "\n"
        }
        
        return labelText
    }
    
    func removeSizeLabel() {
        for child in self.children {
            if child.name == "" {
                child.removeFromParent()
                break
            }
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
            case "orange":
                return SKColor.orange
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
                if level == "instructions" {
                    self.removeAllChildren()
                    self.levelSelected = true
                    showInstructions()
                    run(Sounds.c1)
                    
                } else if level == "reset" {
                    let defaults = UserDefaults.standard
                    defaults.set(String(1), forKey: "highestLevel")
                    self.removeAllChildren()
                    addLevelMenu()
                    run(Sounds.c1)
                    
                } else if level != "0" {
                    self.removeAllChildren()
                    addLevel(levelName: level)
                    run(Sounds.c1)
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
                    var touchedNode: SKNode? = nil
                    if touchedList.count == 1 {
                        touchedNode = touchedList[0]
                    } else {
                        var set = false
                        for n in touchedList {
                            if n.name == "0" {
                                touchedNode = n
                                set = true
                            }
                        }
                        
                        if !set {
                            var sizes = [CGFloat]()
                            var nodes = [SKNode]()
                            for n in touchedList {
                                sizes.append(n.frame.width)
                                nodes.append(n)
                            }
                            
                            touchedNode = nodes[sizes.firstIndex(of: sizes.min()!)!]
                        }
                    }
                    
                    
                    if touchedNode!.name == "0" {
                        // If we touched the level name,
                        // go back to the menu
                        self.removeAllChildren()
                        self.level = 0
                        self.levelSelected = false
                        addLevelMenu()
                        run(Sounds.c1)
                    } else if touchedNode!.name != "" {
                        // Determine the circle change
                        
                        let rate = CGFloat(Float(touchedNode!.name!)!)
                        touchedNode!.setScale(touchedNode!.xScale * rate)
                        
                        // Update the size labels
                        removeSizeLabel()
                        addSizeLabel(text: createSizeLabelContent())
                        playSound(size: touchedNode!.frame.size.width)
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
    
    func playSound(size: CGFloat) {
        if size > 200 {
            run(Sounds.a1)
        } else if size > 175 {
            run(Sounds.b1)
        } else if size > 150 {
            run(Sounds.c1)
        } else if size > 125 {
            run(Sounds.d1)
        } else if size > 100 {
            run(Sounds.e1)
        } else if size > 75 {
            run(Sounds.f1)
        } else {
            run(Sounds.g1)
        }
    }
    
    func showWin() {
        // Set our highest won level
        let defaults = UserDefaults.standard
        defaults.set(String(self.level + 1), forKey: "highestLevel")
        
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
        
        let backLabel = SKLabelNode(text: "back")
        backLabel.fontColor = .black
        backLabel.fontSize = 30
        backLabel.position = CGPoint(x: frameWidth / 2, y: frameHeight / 2 - label.frame.height)
        backLabel.fontName = "Helvetica Neue"
        backLabel.zPosition = 1
        backLabel.name = "0"
    
        self.addChild(label)
        self.addChild(backLabel)
    }
    
    func checkWin() -> Bool {
        var sizes = [Double]()
        for child in self.children {
            if child.name != "0" && child.name != "" {
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
}
