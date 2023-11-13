//
//  CanvasView.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

class Canvas: UIView {

    private var strokeColor = UIColor.black
    private var strokeWidth: Float = 10
    public var isDrawable: Bool = false

    public func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }

    public func setDrawable(state: Bool) {
        self.isDrawable = state
    }

    public func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    public func undoAll() {
        lines.removeAll()
        setNeedsDisplay()
    }

    public func changeWidth(width: Float) {
        self.strokeWidth = width
        setNeedsDisplay()
    }
    public func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
        for(i, p) in line.points.enumerated() {
                if (i == 0) {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if (isDrawable == true) {
            draw()
        }
    }
    var lines = [Line]()


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: [], drawable: isDrawable))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isDrawable == true) {
            guard let point = touches.first?.location(in: nil) else { return }

            guard var lastLine = lines.popLast() else { return }
            lastLine.points.append(point)
            lines.append(lastLine)
            print(point)
            setNeedsDisplay()
        }
    }
}

