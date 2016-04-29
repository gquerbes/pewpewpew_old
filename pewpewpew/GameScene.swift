//
//  GameScene.swift
//  pewpewpew
//
//  Created by Gabriel Querbes on 4/23/16.
//  Copyright (c) 2016 Fourteen66. All rights reserved.
//


//TODO
//PUT PARTICLE NODES IN ARRAY AND CLEAR IT TO SAVE MEMORY
//BETTER COLOR CHANGING BACKGROUND
//POSSIBLY MAKE A MISS DEDUCT 2 POINTS

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    //let dot = SKSpriteNode()
    var score = 0
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    var sprite = SKSpriteNode(imageNamed:"object1")
    var timer =  NSTimer()
    var timer2 =  NSTimer()
    var sparkParticle = SKEmitterNode()
    
    //sounds
    var sound: AVAudioPlayer!
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //score label
        myLabel.text = "Score: \(score)"
        myLabel.fontSize = 45
        myLabel.zPosition = 0
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)  * 1.8))
        self.addChild(myLabel)
        
        //create sprite
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.name = "sprite"
        sprite.zPosition = 1
        self.addChild(sprite)
        sprite.position = CGPointMake(100,100)
        
        
        //timer function to move location
        moveSpriteTimer()
//        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("moveToRandomPosition"), userInfo: nil, repeats: true)

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
    
    func processTap(hit: Bool){
        if(hit){
            
            //reset timer
//            timer.invalidate()
//            timer = NSTimer()
            
            // move sprite
//            moveToRandomPosition()
            
            //increment and update score
            score += 1
            myLabel.text = "Score: \(score)"
            
            //update background color
            self.backgroundColor = getScoreColor()
            
            //play particle
            sparkParticle.position = myLabel.position
            sparkParticle.name = "sparkParticle"
            sparkParticle.targetNode = self.scene
            self.addChild(sparkParticle)
            
            //play sound
            playPewPew()
            
            
            
            //restart moving timer
//            moveSpriteTimer()
        

        }else{
            
            //reset timer
//            timer.invalidate()
//            timer = NSTimer()
            
            // move sprite
//            moveToRandomPosition()
            
            //decrement and update score
            score -= 1
            myLabel.text = "Score: \(score)"
            
            //update background color
            self.backgroundColor = getScoreColor()
            //restart moving timer
//            moveSpriteTimer()
        }
       
    }
    
    func changeSprite(){
        let images = ["object1","object2","object3"]
        let randomNumber = Int(arc4random_uniform(UInt32(images.count)))
        sprite.texture = SKTexture(imageNamed: images[randomNumber])
        
        
    }
    
    
    
    func moveSpriteTimer(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameScene.moveToRandomPosition), userInfo: nil, repeats: true)
        
        //Removing to see how it affects the playing of particles
      //  timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameScene.removeSprites), userInfo: nil, repeats: true)
        
    }
    
    
    func removeSprites(){
        sparkParticle.removeFromParent()
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        var hit = true
        
        
        //particle
        let path = NSBundle.mainBundle().pathForResource("MyParticle", ofType: "sks")
        sparkParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        
        
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
        //remove spark
        //sparkParticle.removeFromParent()
        
        // x coordinate between MinX (left) and MaxX (right):
        let randomX = randomInRange(Int(CGRectGetMinX(self.frame)), hi: Int(CGRectGetMaxX(self.frame)) - 25)
        
        // y coordinate between MinY (top) and MidY (middle):
        let randomY = randomInRange(Int(CGRectGetMinY(self.frame)), hi: Int(CGRectGetMaxY(self.frame)) - 25)

        let aPosition = CGPoint(x: randomX, y: randomY)
        
        return aPosition
    }
    

    
    func moveToRandomPosition() {
            changeSprite()
            let aPosition = getRandomPosition()
            sprite.position = aPosition
           // let number = self["sprite"].count
            let colors = ColorStruct()
            //self.backgroundColor = colors.colorArray[0]
        
            //print("position: \(sprite.position) \(number)")
        
        
    }
   

    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    override func update(currentTime: CFTimeInterval) {
        //self.backgroundColor = UIColor.lightGrayColor()
        
    }
}
