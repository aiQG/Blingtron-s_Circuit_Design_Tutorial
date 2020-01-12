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
	private var unSelectedPointColor: SKKeyframeSequence? = nil
	private var SelectedPointColor: SKKeyframeSequence? = nil
	private var firstPoint: SKEmitterNode? = nil
	private var secondPoint: SKEmitterNode? = nil
	
    override func didMove(to view: SKView) {
		
        let expnode0 = SKEmitterNode(fileNamed: "Point")!
		expnode0.position = CGPoint(x: 100, y: 100)
		expnode0.name = "testPoint0"
		addChild(expnode0)
		
		let expnode1 = SKEmitterNode(fileNamed: "Point")!
		expnode1.position = CGPoint(x: 50, y: 50)
		expnode1.name = "testPoint1"
		addChild(expnode1)
		
		let expnode2 = SKEmitterNode(fileNamed: "Point")!
		expnode2.position = CGPoint(x: 150, y: 50)
		expnode2.name = "testPoint2"
		addChild(expnode2)

		unSelectedPointColor = expnode0.particleColorSequence
    }
    

    override func mouseDown(with event: NSEvent) {
		
		guard let beSelectedPoint = self.nodes(at: event.location(in: self)).first as? SKEmitterNode else {
			return
		}
		
		beSelectedPoint.particleColorSequence = beSelectedPoint.particleColorSequence == SelectedPointColor ? unSelectedPointColor : SelectedPointColor
		
		if firstPoint == nil && beSelectedPoint.particleColorSequence == SelectedPointColor  {
			firstPoint = beSelectedPoint
		} else if firstPoint == beSelectedPoint {
			firstPoint = nil
		} else if firstPoint != beSelectedPoint {
			if beSelectedPoint.particleColorSequence == SelectedPointColor {
				pointSwap(point1: firstPoint!, point2: beSelectedPoint)
			}
		}
		
		
    }
    
	func pointSwap(point1:SKEmitterNode, point2:SKEmitterNode) -> Void {
		print("swap")
		var temp = point1.position.x
		point1.position.x = point2.position.x
		point2.position.x = temp
		
		temp = point1.position.y
		point1.position.y = point2.position.y
		point2.position.y = temp
		
		point1.particleColorSequence = unSelectedPointColor
		point2.particleColorSequence = unSelectedPointColor
		firstPoint = nil
	}
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
