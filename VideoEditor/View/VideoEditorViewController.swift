//
//  VideoEditorViewController.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit
import SnapKit

class VideoEditorViewController: UIViewController {
    private let viewModel = VideoEditorViewModel()
    private let canvas = CanvasView()
    private let picker = UIColorPickerViewController()

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

        bindViewModelToUpdateCanvas()
        bindCanvasToUpdateViewModel()
        addButtons()
    }

    func bindViewModelToUpdateCanvas() {
        viewModel.onUpdateDrawing = { [weak self] lines in
            self?.canvas.lines = lines
        }
    }

    func bindCanvasToUpdateViewModel() {
        canvas.onStartGesture = { [weak self] point in
            self?.viewModel.startNewLine(point: point)
        }

        canvas.onContinueGesture = { [weak self] points in
            self?.viewModel.appendToLastLine(points)
        }
    }

    func addButtons() {
        let size = CGSize(width: 50, height: 50)

        let undoButton = CanvasButton(size: size, image: UIImage(systemName: "arrowshape.turn.up.left.fill")) { [weak self] _ in
            self?.viewModel.undo()
        }

        let colorPicker = CanvasButton(size: size, image: UIImage(systemName: "paintpalette.fill")) { [weak self] _ in
            guard let self else { return }
            picker.delegate = self
            present(picker, animated: true)
        }

        let trashCanButton = CanvasButton(size: size, image: UIImage(systemName: "trash")) { [weak self] _ in
            self?.viewModel.undoAll()
        }

        let uploadViewButton = CanvasButton(size: size, image: UIImage(systemName: "envelope")) { _ in // [weak self]
            print("upload not implemented")
        }

        let toggleDrawing = CanvasButton(size: size, image: UIImage(systemName: "pencil.circle")) { [weak self] _ in
            self?.viewModel.isDrawable.toggle()
        }

        let stackView = UIStackView(arrangedSubviews: [
            undoButton,
            trashCanButton,
            colorPicker,
            uploadViewButton,
            toggleDrawing
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

// MARK: - UIColorPickerViewControllerDelegate

extension VideoEditorViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        viewModel.strokeColor = picker.selectedColor
    }
}
