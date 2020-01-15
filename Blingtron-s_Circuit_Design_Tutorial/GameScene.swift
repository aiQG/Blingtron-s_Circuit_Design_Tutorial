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
	
	
//	var expnode0:SKEmitterNode?
//	var expnode1:SKEmitterNode?
//	var expnode2:SKEmitterNode?
//	var expnode3:SKEmitterNode?
	
//	var skLine:SKShapeNode?
	
	var skShape:SKShapeNode?
	var linePath:CGMutablePath?
	
    override func didMove(to view: SKView) {
		
		skShape = SKShapeNode()
		
		
//        expnode0 = SKEmitterNode(fileNamed: "Point")!
//		expnode0!.position = CGPoint(x: 50, y: 50)
//		expnode0!.zPosition = 1
//		expnode0!.name = "testPoint0"
//		skShape!.addChild(expnode0!)
//
//		expnode1 = SKEmitterNode(fileNamed: "Point")!
//		expnode1!.position = CGPoint(x: 50, y: -50)
//		expnode1!.zPosition = 1
//		expnode1!.name = "testPoint1"
//		skShape!.addChild(expnode1!)
//
//		expnode2 = SKEmitterNode(fileNamed: "Point")!
//		expnode2!.position = CGPoint(x: -50, y: -50)
//		expnode2!.zPosition = 1
//		expnode2!.name = "testPoint2"
//		skShape!.addChild(expnode2!)
//
//		expnode3 = SKEmitterNode(fileNamed: "Point")!
//		expnode3!.position = CGPoint(x: -50, y: 50)
//		expnode3!.zPosition = 1
//		expnode3!.name = "testPoint3"
//		skShape!.addChild(expnode3!)
		
//		skLine = SKShapeNode()
//		linePath = CGMutablePath()
//		linePath!.move(to: CGPoint(x: expnode0!.position.x, y: expnode0!.position.y))
//		linePath!.addLine(to: CGPoint(x: expnode1!.position.x, y: expnode1!.position.y))
//		skLine!.path = linePath
//		skLine!.strokeColor = .red
//		addChild(skLine!)
		
		linePath = CGMutablePath()
		linePath?.addLines(between: [CGPoint(x: -50, y: -50),CGPoint(x: -50, y: 50),CGPoint(x: 50, y: 50),CGPoint(x: 50, y: -50),CGPoint(x: -50, y: -50)])
		skShape?.path = linePath
		skShape?.strokeColor = .red
		addChild(skShape!)
		
		for index in 0...(skShape?.path!.points)!.count-1 {
			let node = SKEmitterNode(fileNamed: "Point")
			node?.position = (skShape?.path!.points)![index]
			node?.zPosition = 1
			node?.name = "testPt\(index)"
			skShape!.addChild(node!)
			unSelectedPointColor = node!.particleColorSequence
		}
		
		
		
		print(skShape?.path?.points)
		
		
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
		let point1Position = SKAction.move(
			to: CGPoint(x: point1.position.x, y: point1.position.y),
			duration: 0.5)
		let point2Position = SKAction.move(
			to: CGPoint(x: point2.position.x, y: point2.position.y),
			duration: 0.5)
		point1.run(point2Position)
		point2.run(point1Position)
		
		//line
		
		print(skShape)
		
		
		
		point1.particleColorSequence = unSelectedPointColor
		point2.particleColorSequence = unSelectedPointColor
		firstPoint = nil
	}
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		
    }
}


extension CGPath {

  ///< this is a computed property
  var points: [CGPoint] {

     ///< this is a local container where we will store our CGPoints
     var arrPoints: [CGPoint] = []

     ///< applyWithBlock lets us examine each element of the CGPath, and decide what to do
     self.applyWithBlock { element in

        switch element.pointee.type
        {
        case .moveToPoint, .addLineToPoint:
          arrPoints.append(element.pointee.points.pointee)

        case .addQuadCurveToPoint:
          arrPoints.append(element.pointee.points.pointee)
          arrPoints.append(element.pointee.points.advanced(by: 1).pointee)

        case .addCurveToPoint:
          arrPoints.append(element.pointee.points.pointee)
          arrPoints.append(element.pointee.points.advanced(by: 1).pointee)
          arrPoints.append(element.pointee.points.advanced(by: 2).pointee)

        default:
          break
        }
     }

    ///< We are now done collecting our CGPoints and so we can return the result
    return arrPoints

  }
}
