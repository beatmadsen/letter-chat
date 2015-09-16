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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        
        path.lineWidth = 2.0
        
        println(self.bounds.size)
}
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            var p = touch.locationInView(self)
            path.moveToPoint(p)
        }
    }

    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            let newPoint = touch.locationInView(self)
            path.addLineToPoint(newPoint)
            self.setNeedsDisplay()
        }

    }
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if incrementalImage == nil {
            drawInitialBitmap()
        }
        
        if let touch = touches.first as? UITouch {
            let newPoint = touch.locationInView(self)
            path.addLineToPoint(newPoint)
            drawBitmap()
            path.removeAllPoints()
            self.setNeedsDisplay()
        }
    }
    
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        touchesEnded(touches, withEvent: event)
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
            var rectPath = UIBezierPath(rect: self.bounds)
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
        
        self.setNeedsDisplay()
    }
}
