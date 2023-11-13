//
//  CanvasViewModel.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

class CanvasViewModel {
    var strokeColor: UIColor = .black
    var strokeWidth: Float = 10
    var isDrawable: Bool = false
    private(set) var lines: [Line] = []
}

extension CanvasViewModel {
    @discardableResult
    func undo() -> Line? {
        lines.popLast()
    }

    func undoAll() {
        lines.removeAll()
    }

    func startNewLine(point: CGPoint?) {
        guard isDrawable else { return }

        let line = Line(strokeWidth: strokeWidth, color: strokeColor, points: [point].compactMap { $0 }, drawable: isDrawable)
        lines.append(line)
    }

    func appendToLastLine(_ point: CGPoint?) {
        guard 
            isDrawable,
            let point
        else { return }

        let index = lines.count - 1
        if index >= 0 {
            lines[index].points.append(point)
        }
    }
}
