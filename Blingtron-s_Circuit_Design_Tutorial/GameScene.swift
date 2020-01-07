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
	private var unSelectedPointColor: SKKeyframeSequence?
	private var SelectedPointColor: SKKeyframeSequence? = nil
	
    override func didMove(to view: SKView) {
		
        let expnode0 = SKEmitterNode(fileNamed: "Point")!
		expnode0.position = CGPoint(x: 100, y: 100)
		expnode0.name = "testPoint0"
		addChild(expnode0)
		
		let expnode1 = SKEmitterNode(fileNamed: "Point")!
		expnode1.position = CGPoint(x: 50, y: 50)
		expnode1.name = "testPoint1"
		addChild(expnode1)

		unSelectedPointColor = expnode0.particleColorSequence
    }
    

    override func mouseDown(with event: NSEvent) {
		
		guard let beSelectedPoint = self.nodes(at: event.location(in: self)).first as? SKEmitterNode else {
			return
		}

		beSelectedPoint.particleColorSequence = beSelectedPoint.particleColorSequence == SelectedPointColor ? unSelectedPointColor : SelectedPointColor
		
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
