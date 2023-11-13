//
//  CanvasView.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

class CanvasView: UIView {
    private let viewModel = CanvasViewModel()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if viewModel.isDrawable {
            draw()
        }
    }
}

// MARK: - Public interface

extension CanvasView {
    func undo() {
        viewModel.undo()
        setNeedsDisplay()
    }

    func undoAll() {
        viewModel.undoAll()
        setNeedsDisplay()
    }

    func changeWidth(width: Float) {
        viewModel.strokeWidth = width
        setNeedsDisplay()
    }
}

// MARK: - Private interface

private extension CanvasView {
    func draw() {
        viewModel.lines.forEach { line in
            let path = line.simplePath
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
            path.lineWidth = CGFloat(line.strokeWidth)

            line.color.setStroke()

            path.stroke()
        }
    }
}

// MARK: - Touches

extension CanvasView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.startNewLine(point: touches.first?.location(in: self))
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.appendToLastLine(touches.first?.location(in: self))
        setNeedsDisplay()
    }
}
