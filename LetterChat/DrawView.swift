//
//  DrawView.swift
//  LetterChat
//
//  Created by Erik Madsen on 12/09/2015.
//  Copyright (c) 2015 Erik Madsen. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var colour: UIColor = UIColor.blackColor()
    
    private var incrementalImage:UIImage?
    
    
    private var path: UIBezierPath = UIBezierPath()
    
    private var rotator: PointRotator! = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.rotator = PointRotator( callback: {
            points in
            
            self.path.moveToPoint(points[0])
            self.path.addCurveToPoint(points[3], controlPoint1: points[1], controlPoint2: points[2])
            self.setNeedsDisplay()
            
            return CGPointMake(0,0) // TODO - change signature
        })
        
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        
        path.lineWidth = 2.0
        
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        
        let p = touch?.locationInView(self)
        
        if let point = p {
            rotator.append(point)
        }
        
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        
        let p = touch?.locationInView(self)
        
        if let point = p {
            rotator.append(point)
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if incrementalImage == nil {
            drawInitialBitmap()
        }
        
        drawBitmap()
        self.setNeedsDisplay()
        rotator.reset()
        path.removeAllPoints()
    }
    
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let t = touches {
            touchesEnded(t, withEvent: event)
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        incrementalImage?.drawInRect(rect)
        colour.setStroke()
        path.stroke()
    }
    
    
    private func doWithinGraphicsContext(action: () -> Void) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        action()
        UIGraphicsEndImageContext()
    }
    
    
    private func drawInitialBitmap() {
        
        doWithinGraphicsContext({
            () -> Void in
            let rectPath = UIBezierPath(rect: self.bounds)
            UIColor.whiteColor().setFill()
            rectPath.fill()
            
            self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        })
    }
    
    
    private func drawBitmap() {
        
        doWithinGraphicsContext({
            () -> Void in
            self.incrementalImage?.drawAtPoint(CGPointZero)
            self.colour.setStroke()
            self.path.stroke()
            
            self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        })
    }
    
    
    func clearLines() {
        
        path.removeAllPoints()
        
        drawInitialBitmap()
        
        self.setNeedsDisplay()
    }
}



class PointRotator {
    private let onRotation: [CGPoint] -> CGPoint
    private var points: [CGPoint] = []
    
    init(callback: [CGPoint] -> CGPoint){
        self.onRotation = callback
    }
    
    func reset() {
        points.removeAll(keepCapacity: true)
    }
    
    func append(newElement: CGPoint){
        points.append(newElement)
        
        if points.count == 5 {
            
            let x = (points[2].x + points[4].x) / 2.0
            let y = (points[2].y + points[4].y) / 2.0
            
            points[3] = CGPointMake(x, y)
            
            onRotation(points)
            
            points.removeFirst(3)
        }
    }
}
