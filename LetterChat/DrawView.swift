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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        
        path.lineWidth = 2.0
        
        print(self.bounds.size)
}
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let p = touch?.locationInView(self)
        
        if let point = p {
            path.moveToPoint(point)
        }
    }

    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let p = touch?.locationInView(self)
        
        if let point = p {
            path.addLineToPoint(point)
            self.setNeedsDisplay()
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if incrementalImage == nil {
            drawInitialBitmap()
        }
        let touch = touches.first
        let p = touch?.locationInView(self)
        
        if let point = p {
            path.addLineToPoint(point)
            drawBitmap()
            path.removeAllPoints()
            self.setNeedsDisplay()
        }
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
        
        self.setNeedsDisplay()
    }
}
