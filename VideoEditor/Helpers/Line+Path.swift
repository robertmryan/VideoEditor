//
//  Line+Path.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

extension Line {
    var simplePath: UIBezierPath {
        let path = UIBezierPath()
        guard let first = points.first else { return path }

        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        return path
    }
}
