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
    let sprite = SKSpriteNode(imageNamed:"Picture2")
    var timer =  NSTimer()
    
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
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
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameScene.moveToRandomPosition), userInfo: nil, repeats: true)
        
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        
        
        for touch: AnyObject in touches {
    
            let location = (touch as! UITouch).locationInNode(self)
            if let theName = self.nodeAtPoint(location).name {
                if theName == "sprite" {
                    
                    score += 1
                    
                    print("hit")
                    print ("score: \(score)")
                    myLabel.text = "Score: \(score)"
                }
            }
            
            else{
               // score -= 1
                myLabel.text = "Score: \(score)"
            }
            sprite.position = getRandomPosition()
        
            
        
            
        }
    }
    
//    func getRandomPosition() -> CGPoint{
//        // x coordinate between MinX (left) and MaxX (right):
//        let randomX = randomInRange(Int(CGRectGetMinX(self.frame)), hi: Int(CGRectGetMidX(self.frame)) + Int(M_PI / 2) - 100)
//        // y coordinate between MinY (top) and MidY (middle):
//        let randomY = randomInRange(Int(CGRectGetMinY(self.frame)), hi: Int(CGRectGetMidY(self.frame)) + Int(M_PI / 2) - 100)
//
//        let aPosition = CGPoint(x: randomX, y: randomY)
//        
//        return aPosition
//    }
    
    func getRandomPosition() -> CGPoint {
        let height = self.view!.frame.height
        let width = self.view!.frame.width
        
        let randomPosition = CGPointMake(CGFloat(arc4random()) % height, CGFloat(arc4random()) % width)
        
        //let sprite = SKSpriteNode()
        return  randomPosition
    }
    
    func moveToRandomPosition() {
       
     
            let aPosition = getRandomPosition()
            sprite.position = aPosition
            let number = self["sprite"].count
            print("position: \(sprite.position) \(number) ")
        
        
       
        
        
        
        //moves sprite to random position 
       // self.sprite.position = randomSpot
        
        
    }
   
//    func moveAround(){
//        dot.position = CGPointMake(0, 0)
//        addChild(dot)
//    }
    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
       // print(score)
       
        
        
    }
}
