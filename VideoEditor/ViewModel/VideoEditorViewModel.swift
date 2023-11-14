//
//  CanvasViewModel.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

class VideoEditorViewModel {
    var strokeColor: UIColor = .blue
    var strokeWidth: Float = 10
    var isDrawable: Bool = true
    private(set) var lines: [Line] = [] { didSet { onUpdateDrawing?(lines) } }
    var onUpdateDrawing: (([Line]) -> Void)?
}

extension VideoEditorViewModel {
    @discardableResult
    func undo() -> Line? {
        lines.popLast()
    }

    func undoAll() {
        lines.removeAll()
    }

    func startNewLine(point: CGPoint?) {
        let line = Line(
            strokeWidth: strokeWidth,
            color: strokeColor,
            points: [point].compactMap { $0 },
            drawable: isDrawable
        )
        lines.append(line)
    }

    func appendToLastLine(_ points: [CGPoint]?) {
        guard let points else { return }

        let index = lines.count - 1
        if index >= 0 {
            lines[index].points.append(contentsOf: points)
        }
    }
}
