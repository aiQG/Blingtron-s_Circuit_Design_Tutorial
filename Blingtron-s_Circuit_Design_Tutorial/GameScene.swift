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
	
	
	var skShape:SKShapeNode?
	var linePath:CGMutablePath?
	
    override func didMove(to view: SKView) {
		
		skShape = SKShapeNode()
		
		
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

//导出CGPath的点数组
extension CGPath {
  var points: [CGPoint] {

     var arrPoints: [CGPoint] = []

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

    return arrPoints
  }
}
