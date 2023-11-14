//
//  CanvasView.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

class CanvasView: UIView {
    var lines: [Line] = [] { didSet { setNeedsDisplay() } }

    var onStartGesture: ((CGPoint?) -> Void)?
    var onContinueGesture: (([CGPoint]) -> Void)?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        lines
            .filter { $0.drawable }
            .forEach { line in
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
        onStartGesture?(touches.first?.location(in: self))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if let touches = event?.coalescedTouches(for: touch) {
            onContinueGesture?(touches.compactMap { $0.location(in: self) })
        } else if let point = touches.first?.location(in: self) {
            onContinueGesture?([point])
        }
    }
}
