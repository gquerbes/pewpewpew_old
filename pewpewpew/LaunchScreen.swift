//
//  LaunchScreen.swift
//  pewpewpew
//
//  Created by Gabriel Querbes on 4/30/16.
//  Copyright © 2016 Fourteen66. All rights reserved.
//


import SpriteKit
import AVFoundation
import UIKit

class LaunchScreen: SKScene {
    let startLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    override func didMoveToView(view: SKView) {
        startLabel.text = "START!"
        startLabel.name = "start"
        startLabel.fontSize = 45
        startLabel.zPosition = 0
        startLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(startLabel)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        for touch: AnyObject in touches {
            
            let location = (touch as! UITouch).locationInNode(self)
            
            if let theName = self.nodeAtPoint(location).name {
                if theName == "start" {
                    let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                    
                    let nextScene = GameScene(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene, transition: transition)
                }
            }
          
        }
    }
}