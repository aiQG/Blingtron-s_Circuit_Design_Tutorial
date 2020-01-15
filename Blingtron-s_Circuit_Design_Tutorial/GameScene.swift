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
    
	private var unSelectedPointColor: SKKeyframeSequence? = nil
	private var SelectedPointColor: SKKeyframeSequence? = nil
	private var firstPoint: SKEmitterNode? = nil
	private var secondPoint: SKEmitterNode? = nil
	
	
	var expnode0:SKEmitterNode?
	var expnode1:SKEmitterNode?
	var expnode2:SKEmitterNode?
	var expnode3:SKEmitterNode?
	
	var skLine:SKShapeNode?
	var linePath:CGMutablePath?
	
	
    override func didMove(to view: SKView) {
		
        expnode0 = SKEmitterNode(fileNamed: "Point")!
		expnode0!.position = CGPoint(x: 50, y: 50)
		expnode0!.zPosition = 1
		expnode0!.name = "testPoint0"
		addChild(expnode0!)
		
		expnode1 = SKEmitterNode(fileNamed: "Point")!
		expnode1!.position = CGPoint(x: 100, y: 50)
		expnode1!.zPosition = 1
		expnode1!.name = "testPoint1"
		addChild(expnode1!)
		
		expnode2 = SKEmitterNode(fileNamed: "Point")!
		expnode2!.position = CGPoint(x: 100, y: 100)
		expnode2!.zPosition = 1
		expnode2!.name = "testPoint2"
		addChild(expnode2!)
		
		expnode3 = SKEmitterNode(fileNamed: "Point")!
		expnode3!.position = CGPoint(x: 50, y: 100)
		expnode3!.zPosition = 1
		expnode3!.name = "testPoint3"
		addChild(expnode3!)
		
		skLine = SKShapeNode()
		linePath = CGMutablePath()
		linePath!.move(to: CGPoint(x: expnode0!.position.x, y: expnode0!.position.y))
		linePath!.addLine(to: CGPoint(x: expnode1!.position.x, y: expnode1!.position.y))
		skLine!.path = linePath
		skLine!.strokeColor = .red
		addChild(skLine!)
		
		unSelectedPointColor = expnode0!.particleColorSequence
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
		print("swap: \(point1) \nand\n \(point2)")
		let point1Position = SKAction.move(to: CGPoint(x: point1.position.x, y: point1.position.y), duration: 0.5)
		let point2Position = SKAction.move(to: CGPoint(x: point2.position.x, y: point2.position.y), duration: 0.5)
		point1.run(point2Position)
		point2.run(point1Position)
		
		//line
		//TODO
		
		
		
		
		point1.particleColorSequence = unSelectedPointColor
		point2.particleColorSequence = unSelectedPointColor
		firstPoint = nil
	}
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		
    }
}
