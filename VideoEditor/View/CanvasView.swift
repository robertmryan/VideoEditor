//
//  CanvasView.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

class Canvas: UIView {
    public var strokeColor: UIColor = .black
    private var strokeWidth: Float = 10
    public var isDrawable: Bool = false
    private var lines: [Line] = []

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isDrawable {
            draw()
        }
    }
}

// MARK: - Public interface

extension Canvas {
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }

    func undoAll() {
        lines.removeAll()
        setNeedsDisplay()
    }

    func changeWidth(width: Float) {
        strokeWidth = width
        setNeedsDisplay()
    }
}

// MARK: - Private interface

private extension Canvas {
    func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        lines.forEach { line in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            for (index, point) in line.points.enumerated() {
                if index == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            context.strokePath()
        }
    }
}

// MARK: - Touches

extension Canvas {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line(strokeWidth: strokeWidth, color: strokeColor, points: [], drawable: isDrawable))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            isDrawable,
            let point = touches.first?.location(in: nil),
            var lastLine = lines.popLast()
        else { return }

        lastLine.points.append(point)
        lines.append(lastLine)
        print(point)
        setNeedsDisplay()
    }
}
