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
	
	var pointList = [
		CGPoint(x: -50, y: -50),
		CGPoint(x: -50, y:  50),
		CGPoint(x:  50, y:  50),
		CGPoint(x:  50, y: -50)
	]
	
	var skShape:SKShapeNode?
	var linePath:CGMutablePath?
	
	var tryLine:SKShapeNode?
	var tryPath0:CGMutablePath?
	var tryPath1:CGMutablePath?
	
	
	
    override func didMove(to view: SKView) {
		// 创建点
		for index in 0...pointList.count-1 {
			let node = SKEmitterNode(fileNamed: "Point")
			node?.position = pointList[index]
			node?.zPosition = 1
			node?.name = "\(index)"
			addChild(node!)
			unSelectedPointColor = node!.particleColorSequence
		}
		
		// 遍历点 并连起
		let pA = childNode(withName: "2")
		let pB = childNode(withName: "0")
		
		let line = SKShapeNode()
		let path = CGMutablePath()
		path.move(to: pB!.position)
		path.addLine(to: pA!.position)
		line.path = path
		line.strokeColor = .red
		line.name = "0-2"
		addChild(line)
		
//		print(path.points)
		
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
		
		//line
		let line: SKShapeNode = (childNode(withName: "\(point1.name!)-\(point2.name!)") ?? childNode(withName: "\(point2.name!)-\(point1.name!)")) as! SKShapeNode
		let topath = CGMutablePath()
		topath.move(to: Int(point1.name!)! < Int(point2.name!)! ? point2.position : point1.position)
		topath.addLine(to: Int(point1.name!)! > Int(point2.name!)! ? point2.position : point1.position)
		print(topath)
		print(line.path)
		line.run(SKAction.lineAnim(fromPath: line.path!, toPath: topath, duration: 0.5))
		
		
		//points
		let point1Position = SKAction.move(
			to: CGPoint(x: point1.position.x, y: point1.position.y),
			duration: 0.5)
		let point2Position = SKAction.move(
			to: CGPoint(x: point2.position.x, y: point2.position.y),
			duration: 0.5)
		point1.run(point2Position)
		point2.run(point1Position)
		
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

//线动画
extension SKAction {
    static func lineAnim(fromPath: CGPath, toPath: CGPath, duration: Double = 0.5) -> SKAction
    {
        return SKAction.customAction(withDuration: duration, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
            let fraction = CGFloat(elapsedTime / CGFloat(duration))
            let start = fromPath
            let end = toPath
            let trans = CGMutablePath()
			trans.move(to: CGPoint(
				x: start.points.first!.x + (end.points.first!.x - start.points.first!.x) * fraction,
				y: start.points.first!.y + (end.points.first!.y - start.points.first!.y) * fraction))
			
			trans.addLine(to: CGPoint(x: start.points.last!.x + (end.points.last!.x - start.points.last!.x) * fraction,
									  y: start.points.last!.y + (end.points.last!.y - start.points.last!.y) * fraction))
			
			(node as? SKShapeNode)?.path = trans
        }
        )
    }
}
