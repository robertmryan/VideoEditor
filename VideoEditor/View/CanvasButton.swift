//
//  CanvasButtonsViewModel.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

final class CanvasButton: UIButton {
    let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return image
    }()
}

// MARK: - Public interface

extension CanvasButton {
    func setConfig(size: CGFloat) -> UIImage.SymbolConfiguration {
        UIImage.SymbolConfiguration(pointSize: size, weight: .bold, scale: .large)
    }

    func configure(with viewModel: CanvasModelButtonModel) {
        addSubview(image)
        image.image = viewModel.image
        image.frame = CGRect(x: 0, y: 0, width: viewModel.width, height: viewModel.height)
    }
}
