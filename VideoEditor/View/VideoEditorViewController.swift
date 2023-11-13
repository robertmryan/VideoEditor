//
//  VideoEditorViewController.swift
//  VideoEditor
//
//  Created by Robert Ryan on 11/13/23.
//

import UIKit
import SnapKit

@objc class VideoEditorViewController: UIViewController {

    let canvas = Canvas()
    let picker = UIColorPickerViewController()


    func setCanvasUI() {
        self.view.addSubview(canvas)
        canvas.backgroundColor = .clear
        let undoButton = CanvasButtonsViewModel(frame: .zero)
        undoButton.configure(with: CanvasModelButtonModel(image:
                                                        UIImage(systemName: "arrowshape.turn.up.left.fill")?
                                                        .withTintColor(.white, renderingMode: .alwaysOriginal), width: 50, height: 50, backgroundColor: .white))
        undoButton.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
        let colorPicker = CanvasButtonsViewModel(frame: .zero)
        colorPicker.configure(with: CanvasModelButtonModel(image:
                                                        UIImage(systemName: "pencil.circle")?
                                                        .withTintColor(.white, renderingMode: .alwaysOriginal), width: 50, height: 50, backgroundColor: .white))
        colorPicker.addTarget(self, action: #selector(ColorPicker), for: .touchUpInside)
        let trashCanButton = CanvasButtonsViewModel(frame: .zero)
        trashCanButton.configure(with: CanvasModelButtonModel(image:
                                                        UIImage(systemName: "trash")?
                                                        .withTintColor(.white, renderingMode: .alwaysOriginal), width: 50, height: 50, backgroundColor: .white))
        trashCanButton.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        let uploadViewButton = CanvasButtonsViewModel(frame: .zero)
        uploadViewButton.configure(with: CanvasModelButtonModel(image:
                                                                    UIImage(systemName: "envelope")?
                                                                    .withTintColor(.white, renderingMode: .alwaysOriginal), width: 51, height: 48, backgroundColor: .white))
        let test = CanvasButtonsViewModel(frame: .zero)
        test.configure(with: CanvasModelButtonModel(image:
                                                                    UIImage(systemName: "pencil.circle")?
                                                                    .withTintColor(.white, renderingMode: .alwaysOriginal), width: 51, height: 48, backgroundColor: .white))
        test.addTarget(self, action: #selector(testdraw), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [
            undoButton,
            trashCanButton,
            colorPicker,
            uploadViewButton,
            test

        ])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.bringSubviewToFront(self.view)
        stackView.spacing = 30
        stackView.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp_rightMargin).offset(-20)
            make.top.equalTo(view.snp_topMargin)
        }
        canvas.frame = view.frame
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCanvasUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension VideoEditorViewController: UIColorPickerViewControllerDelegate, UIImagePickerControllerDelegate {
    @objc func handleUndo() {
        canvas.undo()
    }
    @objc func handleClear() {
        canvas.undoAll()
    }
    @objc func ColorPicker() {
        present(picker, animated: true, completion: nil)
        canvas.setStrokeColor(color: picker.selectedColor)
    }
    @objc func testdraw() {
        if (canvas.isDrawable == false) {
            canvas.setDrawable(state: true)
            return
        }
        if (canvas.isDrawable == true) {
            canvas.setDrawable(state: false)
            return
        }
    }
}
