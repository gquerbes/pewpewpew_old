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
    var score = 0
    var highScore = 0;
    let scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    //user defaults for score
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var sprite = SKSpriteNode(imageNamed:"object1")
    var timer =  NSTimer()
    var timer2 =  NSTimer()
    //particle
    var sparkParticle = SKEmitterNode()
    
    
    //sounds
    var sound: AVAudioPlayer!
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        callForWait()
        
//        //Clear high score
//        userDefaults.setValue(0, forKey: "highScore")
//        userDefaults.synchronize() // don't forget this!!!!
        
        
        if let highScoreOnFile = userDefaults.valueForKey("highScore") {
            // do something here when a highscore exists
            highScore = highScoreOnFile as! Int
        }
        else {
            
        }
        
        
        //score label
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 45
        scoreLabel.zPosition = 0
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)  * 1.8))
        self.addChild(scoreLabel)
        
        //high Score Label
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 20
        highScoreLabel.zPosition = 0
        highScoreLabel.position = CGPoint(x:150, y: 50)
        self.addChild(highScoreLabel)

        
        //create sprite
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.name = "sprite"
        sprite.zPosition = 1
        self.addChild(sprite)
        sprite.position = CGPointMake(100,100)
        
        
        //PARTICLE
        
        let path = NSBundle.mainBundle().pathForResource("MyParticle", ofType: "sks")
        sparkParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        self.addChild(sparkParticle)
        //position particle
        sparkParticle.position = scoreLabel.position

        //END PARTICLE
        
        
        //timer function to move location
        moveSpriteTimer()

    }
    

    
    func playPewPew(){
        sound = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pewpewpew", ofType:"wav")!))
        sound.play()
    }
    
    func getScoreColor() -> UIColor{
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        let color = ColorStruct()
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
        
        var exactColor = color.getExactColor(red, g:green, b: blue)
        
        return exactColor
    }
    
    func callForWait(){
        //setting the delay time 60secs.
        let delay = 10 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            //call the method which have the steps after delay.
            self.stepsAfterDelay()
        }
    }
    
    func stepsAfterDelay(){
        //your code after delay takes place here...
        scoreLabel.text = "gameover"
        
        //return to main screen
        let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
        
        let nextScene = LaunchScreen(size: scene!.size)
        nextScene.scaleMode = .AspectFill
        
        scene?.view?.presentScene(nextScene, transition: transition)
       
    }
    
    func processTap(hit: Bool){
        if(hit){
            

            
            sparkParticle.resetSimulation()
            
            //increment and update score
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            //update background color
            self.backgroundColor = getScoreColor()
            
            
            
            //play sound
            playPewPew()
            
        
        

        }else{
            //decrement and update score
            score -= 1
            scoreLabel.text = "Score: \(score)"
            
            //update background color
            self.backgroundColor = getScoreColor()
        }
        if score > highScore{
            setNewHighScore()
        }
    }
    
    func changeSprite(){
        let images = ["object1","object2","object3"]
        let randomNumber = Int(arc4random_uniform(UInt32(images.count)))
        sprite.texture = SKTexture(imageNamed: images[randomNumber])
    }
    
    
    
    func moveSpriteTimer(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        // Increasing this interval will slow down the movement of targets
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameScene.moveToRandomPosition), userInfo: nil, repeats: true)
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
            changeSprite()
            let aPosition = getRandomPosition()
            sprite.position = aPosition
    }
   

    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    override func update(currentTime: CFTimeInterval) {
        //self.backgroundColor = UIColor.lightGrayColor()
        
    }

    
}
