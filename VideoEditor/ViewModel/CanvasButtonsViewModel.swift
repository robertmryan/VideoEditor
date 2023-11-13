//
//  CanvasButtonsViewModel.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit

final class CanvasButtonsViewModel: UIButton {
    let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return image
    }()

    func setConfig(size: CGFloat) -> UIImage.SymbolConfiguration {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .bold, scale: .large)
        return largeConfig
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: CanvasModelButtonModel) {
        addSubview(image)
        image.image = viewModel.image
        image.frame = CGRect(x: 0, y: 0, width: viewModel.width, height: viewModel.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

