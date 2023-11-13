//
//  VideoEditorViewController.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit
import SnapKit

@objc class VideoEditorViewController: UIViewController {
    let canvas = CanvasView()
    let picker = UIColorPickerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setCanvasUI()
    }
}

// MARK: - Private interface

private extension VideoEditorViewController {
    func setCanvasUI() {
        view.addSubview(canvas)
        canvas.backgroundColor = .clear

        let undoButton = CanvasButton(frame: .zero)
        undoButton.configure(
            with: CanvasModelButtonModel(
                image: UIImage(systemName: "arrowshape.turn.up.left.fill")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal),
                width: 50,
                height: 50,
                backgroundColor: .white
            )
        )
        undoButton.addTarget(self, action: #selector(handleUndo(_:)), for: .touchUpInside)

        let colorPicker = CanvasButton(frame: .zero)
        colorPicker.configure(
            with: CanvasModelButtonModel(
                image: UIImage(systemName: "pencil.circle")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal),
                width: 50,
                height: 50,
                backgroundColor: .white
            )
        )
        colorPicker.addTarget(self, action: #selector(colorPicker(_:)), for: .touchUpInside)

        let trashCanButton = CanvasButton(frame: .zero)
        trashCanButton.configure(
            with: CanvasModelButtonModel(
                image: UIImage(systemName: "trash")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal),
                width: 50,
                height: 50,
                backgroundColor: .white
            )
        )
        trashCanButton.addTarget(self, action: #selector(handleClear(_:)), for: .touchUpInside)

        let uploadViewButton = CanvasButton(frame: .zero)
        uploadViewButton.configure(
            with: CanvasModelButtonModel(
                image: UIImage(systemName: "envelope")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal),
                width: 51,
                height: 48,
                backgroundColor: .white
            )
        )

        let test = CanvasButton(frame: .zero)
        test.configure(
            with: CanvasModelButtonModel(
                image: UIImage(systemName: "pencil.circle")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal),
                width: 51,
                height: 48,
                backgroundColor: .white
            )
        )
        test.addTarget(self, action: #selector(testDraw(_:)), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [
            undoButton,
            trashCanButton,
            colorPicker,
            uploadViewButton,
            test
        ])
        view.addSubview(stackView)

        stackView.axis = .vertical
        stackView.bringSubviewToFront(view)
        stackView.spacing = 30
        stackView.snp.makeConstraints { make in
            make.right.equalTo(view.snp_rightMargin).offset(-20)
            make.top.equalTo(view.snp_topMargin)
        }
        canvas.frame = view.frame
    }
}

// MARK: - Actions

extension VideoEditorViewController {
    @objc func handleUndo(_ sender: Any) {
        canvas.undo()
    }

    @objc func handleClear(_ sender: Any) {
        canvas.undoAll()
    }

    @objc func colorPicker(_ sender: Any) {
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func testDraw(_ sender: Any) {
        canvas.isDrawable.toggle()
    }
}

// MARK: - UIColorPickerViewControllerDelegate

extension VideoEditorViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        canvas.strokeColor = picker.selectedColor
    }
}
