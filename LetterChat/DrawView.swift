//
//  DrawView.swift
//  LetterChat
//
//  Created by Erik Madsen on 12/09/2015.
//  Copyright (c) 2015 Erik Madsen. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    private var linesByColour: [UIColor:[Line]] = [:]
    private var lastPoint: CGPoint! // implicitly unwrapped optional, i.e. it will behave like a normal var, but it may be nil
    
    var colour: UIColor = UIColor.blackColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        linesByColour.updateValue([], forKey: UIColor.redColor())
        linesByColour.updateValue([], forKey: UIColor.blackColor())
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            lastPoint = touch.locationInView(self)
        }
        super.touchesBegan(touches, withEvent: event)
    }

    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            let newPoint = touch.locationInView(self)
            addPoint(newPoint)
            lastPoint = newPoint
        }
        super.touchesBegan(touches, withEvent: event)
        self.setNeedsDisplay()

    }
    
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextBeginPath(context)
        CGContextSetLineWidth(context, 5)
        CGContextSetLineCap(context, kCGLineCapRound)
        
        for (colour, lines) in linesByColour {
            
            CGContextSetStrokeColorWithColor(context, colour.CGColor)
     
            for line in lines {
                CGContextMoveToPoint(context, line.start.x, line.start.y)
                CGContextAddLineToPoint(context, line.end.x, line.end.y)
            }
            CGContextStrokePath(context)
        }
    }
    
    
    func clearLines() {
        
        for key in linesByColour.keys {
            linesByColour[key]!.removeAll(keepCapacity: true)
        }
        
        self.setNeedsDisplay()
    }
    
    
    private func addPoint(point: CGPoint) {
        linesByColour[colour]?.append(Line(start: lastPoint, end: point))
    }
}

struct Line {
    let start: CGPoint
    let end: CGPoint
}