//
//  Canvas.swift
//  Strokescape
//
//  Created by IPH Technologies Pvt. Ltd. on 08/08/23.
//

import UIKit

class Canvas: UIView{
    var lines = [Line]()
    var strokeColor = UIColor.black
    var straightLineIdentifier = false
    var deletedLines = [Line]()
    var startPoint = CGPoint()
    var endPoint = CGPoint()
    var id = false
    
    var multiLineIdentifier = false
    
    func undo(){
        if lines.count != 0{
            let last = lines.popLast()
            deletedLines.append(last!)
            setNeedsDisplay()
        }
    }
    
    func redo(){
        if(deletedLines.count != 0){
            let last = deletedLines.removeLast()
            lines.append(last)
            setNeedsDisplay()
        }
    }
    
    func clear(){
        lines.removeAll()
        setNeedsDisplay()
    }
    
    func inkColor(color: UIColor){
        self.strokeColor = color
    }
    
    func eraser(){
        self.strokeColor = UIColor.white
    }
    
    func defaultPencil(){
        self.strokeColor = UIColor.black
    }
    //renders lines on the screen. It gets called automatically when the view needs to be redrawn.
    override func draw(_ rect: CGRect) {
        //returns current graphics context which is where the drawing operations take place.
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
            lines.forEach { (line) in
                //styling the line drawn
                context.setStrokeColor(line.color.cgColor)
                context.setLineWidth(10.0)
                context.setLineCap(.round)
                
                for (i, p) in line.points.enumerated(){
                    if multiLineIdentifier{
                        context.move(to: startPoint)
                        context.addLine(to: p)
                    }else{
                        if i == 0{
                            //begin line from specified point
                            context.move(to: p)
                        }
                        else{
                            //appends line
                            context.addLine(to: p)
                        }
                    }
                }
                //paints a line along the given path
                context.strokePath()
            }
        }
    //track the movement of finger
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if straightLineIdentifier {
            if let touch = touches.first {
                    let position = touch.location(in: self)
                    startPoint = position
                    endPoint = position
                    lines.append(Line.init(color: strokeColor, points: [startPoint, endPoint]))
            }
        }
        else{
                //appending lines in lines array.
                lines.append(Line.init(color: strokeColor, points: []))
            }
        if multiLineIdentifier{
            if let touch = touches.first {
                let position = touch.location(in: self)
                if id == true{
                    startPoint = position
                    // endPoint = position
                    //lines.append(Line.init(color: strokeColor, width: strokeWidth, points: [startPoint, endPoint]))
                    //lines.append(Line.init(color: strokeColor, width: strokeWidth, points: []))
                    id = false
                }
                else{
                   endPoint = position
                   guard var lastLineAdded = lines.popLast() else{ return }
//                    lastLineAdded.points[1] = endPoint
                   lastLineAdded.points.append(endPoint)
                   lines.append(lastLineAdded)
               }
            }
        }
        setNeedsDisplay()
        }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       if straightLineIdentifier{
            if let touch = touches.first {
                let position = touch.location(in: self)
                endPoint = position
                guard var lastLineAdded = lines.popLast() else{ return}
                lastLineAdded.points[1] = endPoint
                lines.append(lastLineAdded)
            }
        }
        else{
            //keeps track of the points at which user touches the screen
            guard let point = touches.first?.location(in: nil) else {
                return
            }
            guard var lastLine = lines.popLast() else{
                return
            }
            lastLine.points.append(point)
            lines.append(lastLine)
        }
        //everytime screen is touched draw method is called which renders the line.
        setNeedsDisplay()
    }
}
