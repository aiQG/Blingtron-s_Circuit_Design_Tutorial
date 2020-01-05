//
//  GameScene.swift
//  Blingtron-s_Circuit_Design_Tutorial
//
//  Created by 周测 on 1/5/20.
//  Copyright © 2020 aiQG_. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        let expnode = SKEmitterNode(fileNamed: "Point")!
		expnode.position = CGPoint(x: 100, y: 100)
		expnode.name = "testPoint"
		addChild(expnode)
		
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }

    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
//		print(event.allTouches().first!)
		print(self.nodes(at: event.location(in: self)))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
