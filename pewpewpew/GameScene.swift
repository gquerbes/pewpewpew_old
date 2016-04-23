//
//  GameScene.swift
//  pewpewpew
//
//  Created by Gabriel Querbes on 4/23/16.
//  Copyright (c) 2016 Fourteen66. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    //let dot = SKSpriteNode()
    var score = 0
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    var sprite = SKSpriteNode(imageNamed:"fax")
    var timer =  NSTimer()
    var sparkParticle = SKEmitterNode()
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        //score label
        myLabel.text = "Score: \(score)"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
        
        //create sprite
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.name = "sprite"
        self.addChild(sprite)
        sprite.position = CGPointMake(100,100)
        
        
        //timer function
        scheduledTimerWithTimeInterval()
//        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("moveToRandomPosition"), userInfo: nil, repeats: true)
        
        

    }
    
    func changeSprite(){
        let images = ["clouds","mail","pen","Spaceship","building","fax"]
        let randomNumber = Int(arc4random_uniform(UInt32(images.count)))
        sprite.texture = SKTexture(imageNamed: images[randomNumber])
        
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameScene.moveToRandomPosition), userInfo: nil, repeats: true)
        
        
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        //particle
        let path = NSBundle.mainBundle().pathForResource("MyParticle", ofType: "sks")
        sparkParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        
        
        for touch: AnyObject in touches {
            
            let location = (touch as! UITouch).locationInNode(self)
            if let theName = self.nodeAtPoint(location).name {
                if theName == "sprite" {
                    
                    score += 1
                    
                    print("hit")
                    print ("score: \(score)")
                    myLabel.text = "Score: \(score)"
                    changeSprite()
                    sprite.position = getRandomPosition()
                    sparkParticle.position = sprite.position
                    sparkParticle.name = "sparkParticle"
                    sparkParticle.targetNode = self.scene
                    self.addChild(sparkParticle)
                    
                    
                }
            }
            
            else{
                score -= 1
                myLabel.text = "Score: \(score)"
                
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
            let aPosition = getRandomPosition()
            sprite.position = aPosition
            let number = self["sprite"].count
            print("position: \(sprite.position) \(number) ")
            sparkParticle.removeFromParent()
        
    }
   

    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}
