//
//  GameScene.swift
//  Blingtron-s_Circuit_Design_Tutorial
//
//  Created by 周测 on 1/5/20.
//  Copyright © 2020 aiQG_. All rights reserved.
//

import SpriteKit
import GameplayKit
import simd //矩阵、向量运算

class GameScene: SKScene {
	
	private var unSelectedPointColor: SKKeyframeSequence? = nil
	private var SelectedPointColor: SKKeyframeSequence? = nil
	private var firstPoint: SKEmitterNode? = nil
	private var secondPoint: SKEmitterNode? = nil
	private let CrossLineColor: NSColor = NSColor(red: 1, green: 0.1, blue: 0.1, alpha: 1)
	private let unCrossLineColor: NSColor = NSColor(red: 0.2, green: 0.5, blue: 1, alpha: 1)
	
	
	var pointList = [
		CGPoint(x: -50, y: -50),
		CGPoint(x: -50, y:  50),
		CGPoint(x:  50, y:  50),
		CGPoint(x:  50, y: -50)
	]
	
	var lineArr: [SKShapeNode] = []
	
	
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
		
		// 遍历点 并连起 线保存到数组
		for i in 0 ..< pointList.count {
			//pA点为name小的, pB为name大的
			let pA = childNode(withName: i < (i + 1) % pointList.count ? "\(i)" : "\((i + 1) % pointList.count)")
			let pB = childNode(withName: i > (i + 1) % pointList.count ? "\(i)" : "\((i + 1) % pointList.count)")
			
			let line = SKShapeNode()
			let path = CGMutablePath()
			path.move(to: pA!.position)
			path.addLine(to: pB!.position)
			line.path = path
			line.strokeColor = unCrossLineColor
			line.lineWidth = 3
			line.name = "\(pA!.name!)-\(pB!.name!)"
			addChild(line)
			lineArr.append(line)
		}
		
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
		//lines
		for i in lineArr {
			let topath = CGMutablePath()
			//线起点
			if i.name!.hasPrefix(point1.name!) {
				topath.move(to: point2.position)
			} else if i.name!.hasPrefix(point2.name!) {
				topath.move(to: point1.position)
			} else {
				topath.move(to: i.path!.points.first!)
			}
			//线终点
			if i.name!.hasSuffix(point1.name!) {
				topath.addLine(to: point2.position)
			} else if i.name!.hasSuffix(point2.name!) {
				topath.addLine(to: point1.position)
			} else {
				topath.addLine(to: i.path!.points.last!)
			}
			
			i.run(SKAction.lineAnim(fromPath: i.path!, toPath: topath, duration: 0.5))
		}
		
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
		// 实时更新线的颜色(是否交叉)
		for i in 0 ..< lineArr.count {
			var flag: Bool = false
			for j in 0 ..< lineArr.count {
				if i == j {
					continue
				}
				let selfPathPoint = lineArr[i].path?.points
				let otherPathPoint = lineArr[j].path?.points
				// 计算selfPath和otherPath是否交叉
				let v1 = simd_double2(x: Double((selfPathPoint?.last!.x)! - (selfPathPoint?.first!.x)!), y: Double((selfPathPoint?.last!.y)! - (selfPathPoint?.first!.y)!))
				let v2 = simd_double2(x: Double((otherPathPoint?.first!.x)! - (selfPathPoint?.first!.x)!), y: Double((otherPathPoint?.first!.y)! - (selfPathPoint?.first!.y)!))
				let v3 = simd_double2(x: Double((otherPathPoint?.last!.x)! - (selfPathPoint?.first!.x)!), y: Double((otherPathPoint?.last!.y)! - (selfPathPoint?.first!.y)!))
				let x0 = simd_double2x2([v1, v2]).determinant
				let x1 = simd_double2x2([v1, v3]).determinant
				// x0 * x1 < 0 为交叉
				flag = flag || (x0 * x1 < 0.0) ? true : false
			}
			lineArr[i].strokeColor = flag ? CrossLineColor : unCrossLineColor
		}
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

extension SKAction {
	// 线动画
	static func lineAnim(fromPath: CGPath, toPath: CGPath, duration: Double = 0.5) -> SKAction {
		return SKAction.customAction(withDuration: duration){ (node: SKNode!, elapsedTime: CGFloat) -> Void in
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
	}
}
