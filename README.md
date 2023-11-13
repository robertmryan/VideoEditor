#  VideoEditor

This is a repo to represent the question posed on Code Review: https://codereview.stackexchange.com/q/252418/54422

> im trying to migrate my very large swift view controller to mvvm but it still feels very large, can you guys give me any advice 
> 
> What this controller does is simple it shows a UIView on which i can draw the buttons that I display are here to manage the lines that i have drawn on the canvas. 
> 
> For example to delete the last line drawn, delete all lines, change the color etc ... 
> 
> What I want to do is to create my buttons while conforming to MVVM, so its not as ugly as my view controller is right now 
> 
> ```swift
> @objc class VideoEditorViewController: UIViewController {
>     
>     let canvas = Canvas()
>     let picker = UIColorPickerViewController()
>     
>     
>     func setCanvasUI() {
>         self.view.addSubview(canvas)
>         canvas.backgroundColor = .clear
>         let undoButton = CanvasButtonsViewModel(frame: .zero)
>         undoButton.configure(with: CanvasModelButtonModel(image:
>                                                         UIImage(systemName: "arrowshape.turn.up.left.fill")?
>                                                         .withTintColor(.white, renderingMode: .alwaysOriginal), width: 50, height: 50, backgroundColor: .white))
>         undoButton.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
>         let colorPicker = CanvasButtonsViewModel(frame: .zero)
>         colorPicker.configure(with: CanvasModelButtonModel(image:
>                                                         UIImage(systemName: "pencil.circle")?
>                                                         .withTintColor(.white, renderingMode: .alwaysOriginal), width: 50, height: 50, backgroundColor: .white))
>         colorPicker.addTarget(self, action: #selector(ColorPicker), for: .touchUpInside)
>         let trashCanButton = CanvasButtonsViewModel(frame: .zero)
>         trashCanButton.configure(with: CanvasModelButtonModel(image:
>                                                         UIImage(systemName: "trash")?
>                                                         .withTintColor(.white, renderingMode: .alwaysOriginal), width: 50, height: 50, backgroundColor: .white))
>         trashCanButton.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
>         let uploadViewButton = CanvasButtonsViewModel(frame: .zero)
>         uploadViewButton.configure(with: CanvasModelButtonModel(image:
>                                                                     UIImage(systemName: "envelope")?
>                                                                     .withTintColor(.white, renderingMode: .alwaysOriginal), width: 51, height: 48, backgroundColor: .white))
>         let test = CanvasButtonsViewModel(frame: .zero)
>         test.configure(with: CanvasModelButtonModel(image:
>                                                                     UIImage(systemName: "pencil.circle")?
>                                                                     .withTintColor(.white, renderingMode: .alwaysOriginal), width: 51, height: 48, backgroundColor: .white))
>         test.addTarget(self, action: #selector(testdraw), for: .touchUpInside)
>         let stackView = UIStackView(arrangedSubviews: [
>             undoButton,
>             trashCanButton,
>             colorPicker,
>             uploadViewButton,
>             test
>             
>         ])
>         view.addSubview(stackView)
>         stackView.axis = .vertical
>         stackView.bringSubviewToFront(self.view)
>         stackView.spacing = 30
>         stackView.snp.makeConstraints { (make) in
>             make.right.equalTo(view.snp_rightMargin).offset(-20)
>             make.top.equalTo(view.snp_topMargin)
>         }
>         canvas.frame = view.frame
>     }
>     
>     override func viewDidAppear(_ animated: Bool) {
>         super.viewDidAppear(animated)
>         setCanvasUI()
>     }
>     
>     override func viewDidLoad() {
>         super.viewDidLoad()
>     }
> }
> 
> 
> extension VideoEditorViewController: UIColorPickerViewControllerDelegate, UIImagePickerControllerDelegate {
>     @objc func handleUndo() {
>         canvas.undo()
>     }
>     @objc func handleClear() {
>         canvas.undoAll()
>     }
>     @objc func ColorPicker() {
>         present(picker, animated: true, completion: nil)
>         canvas.setStrokeColor(color: picker.selectedColor)
>     }
>     @objc func testdraw() {
>         if (canvas.isDrawable == false) {
>             canvas.setDrawable(state: true)
>             return
>         }
>         if (canvas.isDrawable == true) {
>             canvas.setDrawable(state: false)
>             return
>         }
>     }
> }
> ```
>
> Canvas View : 
> 
> ```swift
> import Foundation
> import UIKit
> import SnapKit
> 
> class Canvas: UIView {
>     
>     private var strokeColor = UIColor.black
>     private var strokeWidth: Float = 10
>     public var isDrawable: Bool = false
>     
>     public func setStrokeColor(color: UIColor) {
>         self.strokeColor = color
>     }
>     
>     public func setDrawable(state: Bool) {
>         self.isDrawable = state
>     }
>     
>     public func undo() {
>         _ = lines.popLast()
>         setNeedsDisplay()
>     }
>     public func undoAll() {
>         lines.removeAll()
>         setNeedsDisplay()
>     }
>     
>     public func changeWidth(width: Float) {
>         self.strokeWidth = width
>         setNeedsDisplay()
>     }
>     public func draw() {
>         guard let context = UIGraphicsGetCurrentContext() else { return }
>     
>         lines.forEach { (line) in
>             context.setStrokeColor(line.color.cgColor)
>             context.setLineWidth(CGFloat(line.strokeWidth))
>             context.setLineCap(.round)
>         for(i, p) in line.points.enumerated() {
>                 if (i == 0) {
>                     context.move(to: p)
>                 } else {
>                     context.addLine(to: p)
>                 }
>             }
>             context.strokePath()
>         }
>     }
>     
>     override func draw(_ rect: CGRect) {
>         super.draw(rect)
>         if (isDrawable == true) {
>             draw()
>         }
>     }
>     var lines = [Line]()
>     
>     
>     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
>         lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: [], drawable: isDrawable))
>     }
>     
>     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
>         if (isDrawable == true) {
>             guard let point = touches.first?.location(in: nil) else { return }
>         
>             guard var lastLine = lines.popLast() else { return }
>             lastLine.points.append(point)
>             lines.append(lastLine)
>             print(point)
>             setNeedsDisplay()
>         }
>     }
> }
> ```
> 
> Canvas Struct to draw lines : 
> 
> ```swift
> struct Line {
>     let strokeWidth: Float
>     let color: UIColor
>     var points: [CGPoint]
>     var drawable: Bool
> }
> ```
> 
> My view model 
> 
> ```swift
> final class CanvasButtonsViewModel: UIButton {
>     
>     let image: UIImageView = {
>         let image = UIImageView()
>         image.image = UIImage()
>         image.image?.withTintColor(.white, renderingMode: .alwaysOriginal)
>         return image
>     }()
> 
>     func setConfig(size: CGFloat) -> UIImage.SymbolConfiguration {
>         let largeConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .bold, scale: .large)
>         return largeConfig
>     }
>     
>     override init(frame: CGRect) {
>         super.init(frame: frame)
>     }
>     required init?(coder: NSCoder) {
>         fatalError("init(coder:) has not been implemented")
>     }
>     func configure(with viewModel: CanvasModelButtonModel) {
>         self.addSubview(image)
>         image.image = viewModel.image
>         image.frame = CGRect(x: 0, y: 0, width: viewModel.width, height: viewModel.height)
>     }
>     override func layoutSubviews() {
>         super.layoutSubviews()
>     }
> }
> ```
>
> The model 
> 
> ```swift
> struct CanvasModelButtonModel {
>     let image: UIImage?
>     let width: CGFloat
>     let height: CGFloat
>     let backgroundColor: UIColor?
> }
> ```
