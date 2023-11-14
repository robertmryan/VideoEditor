//
//  CanvasButtonsViewModel.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

final class CanvasButton: UIButton {
    private var action: (CanvasButton) -> Void

    init(size: CGSize = .zero, image: UIImage?, action: @escaping (CanvasButton) -> Void) {
        self.action = action

        super.init(frame: CGRect(origin: .zero, size: size))

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])

        setImage(
            image?.withTintColor(.white, renderingMode: .alwaysOriginal),
            for: .normal
        )

        addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTap(_ sender: CanvasButton) {
        action(sender)
    }
}
