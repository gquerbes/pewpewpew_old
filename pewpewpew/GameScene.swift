//
//  GameScene.swift
//  pewpewpew
//
//  Created by Gabriel Querbes on 4/23/16.
//  Copyright (c) 2016 Fourteen66. All rights reserved.
//


//TODO
//BETTER COLOR CHANGING BACKGROUND
//POSSIBLY MAKE A MISS DEDUCT 2 POINTS

import SpriteKit
import AVFoundation
import UIKit


class GameScene: SKScene {
    ///score variables
    var score = 0
    var highScore = 0;
    
    ///labels
    let scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    var highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    ///phone local storage
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    ///visual objects
    var target = SKSpriteNode(imageNamed:"object1")
    
    ///particles
    var sparkParticle = SKEmitterNode()
    
    ///timers
    var timer =  NSTimer()
    
    ///sounds
    var sound: AVAudioPlayer!
    
    /**
    Configure view upon presenting it
    */
    override func didMoveToView(view: SKView) {
        ///start timer
        startGameTimer()
        
        /*
        //Clear high score from local storage
        userDefaults.setValue(0, forKey: "highScore")
        userDefaults.synchronize()
        */
        
        ///Check if high score is on local storage and set it on game
        if let highScoreOnFile = userDefaults.valueForKey("highScore") {
            /// do something here when a high score exists
            highScore = highScoreOnFile as! Int
        }
        
        
        ///score label properties
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 45
        scoreLabel.zPosition = 0
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)  * 1.8))
        ///add score label to scene
        self.addChild(scoreLabel)
        
        ///high Score Label properties
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 20
        highScoreLabel.zPosition = 0
        highScoreLabel.position = CGPoint(x:150, y: 50)
        ///add high score label to scene
        self.addChild(highScoreLabel)

        
        ///target sprite properties
        target.xScale = 0.5
        target.yScale = 0.5
        target.name = "sprite"
        target.zPosition = 1
        ///add target to scene
        self.addChild(target)
        target.position = CGPointMake(100,100)
        
        
        ///move the location of the target repeatedly
        moveTargetOnTimer()
        
        
        ///particle location
        let path = NSBundle.mainBundle().pathForResource("MyParticle", ofType: "sks")
        ///particle instantiation
        sparkParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        ///set particle position
        sparkParticle.position = scoreLabel.position
        ///add particle to scene
        self.addChild(sparkParticle)

    }
    

    ///play sound file
    func playPewPew(){
        ///select sound file
        sound = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pewpewpew", ofType:"wav")!))
        ///play sound file
        sound.play()
    }
    
    /**
    gets background color to match score
     
    - Returns: a color that matches the current game score
    */
    func getScoreColor() -> UIColor{
        ///declare number values for each RGB
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        
        ///get ColorStruct class to call colors
        let color = ColorStruct()
        
        ///check score and alter color number values accordingly
        if (score == 0){
            red = 206
            green = 206
            blue = 206
        }
        else if (score > 0){
            red = 0
            green = 100 + (CGFloat(score) * 10)
            blue = 0
        }
        else{
            red = 100 + (CGFloat(abs(score)) * 10)
            green = 0
            blue = 0
        }
        
        ///create color using RGB color variables
        let exactColor = color.getExactColor(red, g:green, b: blue)
        
        ///return new color
        return exactColor
    }
    
    
    /**
    start countdown timer and call end of gameplay
    */
    func startGameTimer(){
        ///setting the delay time in secs.
        let delay = 10 * Double(NSEC_PER_SEC)
        
        ///run timer
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            ///call to end the game
            self.endOfGame()
        }
    }
    
    /**
    signal the end of game
    */
    func endOfGame(){
        
        ///configure transition to next scene
        let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
        
        ///set next scene to launch screen
        let nextScene = LaunchScreen(size: scene!.size)
        
        ///set next scence scale mode
        nextScene.scaleMode = .AspectFill
        
        //present next scene
        scene?.view?.presentScene(nextScene, transition: transition)
       
    }
    
    
    /**
    process the actions to take after a tap is registered
     
    - Parameter hit: true if target hit
    */
    func processTap(hit: Bool){
        ///if target was hit
        if(hit){
            ///play the particle
            sparkParticle.resetSimulation()
            
            ///increment score
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            
            
            ///play sound
            playPewPew()
        }
        ///if target was NOT hit
        else{
            ///decrement score
            score -= 1
            scoreLabel.text = "Score: \(score)"
           
        }
        ///update background color
        self.backgroundColor = getScoreColor()
        
        ///update high score if old record beat
        if score > highScore{
            setNewHighScore()
        }
    }
    
    /**
    update the target Sprite to a random texture
    */
    func changeTarget(){
        ///list of available images to use as textures
        let images = ["object1","object2","object3"]
        
        ///select random number witin range of images array
        let randomNumber = Int(arc4random_uniform(UInt32(images.count)))
        
        ///set texture of target to random number
        target.texture = SKTexture(imageNamed: images[randomNumber])
    }
    
    /**
    Timer to move target
    */
    func moveTargetOnTimer(){
        // Increasing this interval will slow down the movement of targets
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.moveToRandomPosition), userInfo: nil, repeats: true)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        var hit = true

        for touch: AnyObject in touches {
            
            let location = (touch as! UITouch).locationInNode(self)
            hit = false;
            if let theName = self.nodeAtPoint(location).name {
                if theName == "sprite" {
                    hit = true
                    processTap(hit)
                }
            }
            else{
                processTap(hit)
             
            }
        }
    }
    
    func getRandomPosition() -> CGPoint{
        
        // x coordinate between MinX (left) and MaxX (right):
        let randomX = randomInRange(Int(CGRectGetMinX(self.frame)), hi: Int(CGRectGetMaxX(self.frame)) - 25)
        
        // y coordinate between MinY (top) and MidY (middle):
        let randomY = randomInRange(Int(CGRectGetMinY(self.frame)), hi: Int(CGRectGetMaxY(self.frame)) - 25)

        let aPosition = CGPoint(x: randomX, y: randomY)
        
        return aPosition
    }
    
    func setNewHighScore(){
        highScore = score
        highScoreLabel.text = "New High Score: \(highScore)"
        
        //write high score to memory
        userDefaults.setValue(highScore, forKey: "highScore")
        userDefaults.synchronize() // don't forget this!!!!
    }
    
    func moveToRandomPosition() {
            changeTarget()
            let aPosition = getRandomPosition()
            target.position = aPosition
    }
   

    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    override func update(currentTime: CFTimeInterval) {
        //self.backgroundColor = UIColor.lightGrayColor()
        
    }

    
}
