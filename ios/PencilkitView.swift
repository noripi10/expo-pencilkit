import Foundation
import PencilKit

class PencilkitView: UIView, PKToolPickerObserver, UIGestureRecognizerDelegate, PKCanvasViewDelegate {
    private let templateImageView = UIImageView()
    private var imageData: String = ""

    private var toolPicker: PKToolPicker?
    // var undoManager: UndoManager?

    lazy var canvas: PKCanvasView = {
        let canvasView = PKCanvasView()
        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        }
        canvasView.isMultipleTouchEnabled = true
        canvasView.isOpaque = true
        canvasView.backgroundColor = .clear

        // undoManager = canvasView.undoManager

        return canvasView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(canvas)
        showToolPicker()
    }

    required init?(coder: NSCoder) {
        fatalError("Coder init has not been implemented yet")
    }

    override func layoutSubviews() {
        canvas.delegate = self
        canvas.frame = bounds
        canvas.becomeFirstResponder()

        createImage()
    }

    func showToolPicker() {
        if #available(iOS 14.0, *) {
            toolPicker = PKToolPicker()
            toolPicker?.setVisible(true, forFirstResponder: canvas)
            toolPicker?.addObserver(canvas)
        }
    }

    func createImage() {
        guard let data = Data(base64Encoded: self.imageData) else {
            return
        }
        let image = UIImage(data: data)
        templateImageView.image = image

        // templateImageView.frame = canvas.bounds
        templateImageView.frame = CGRect(x: 0, y: 0, width: canvas.bounds.width, height: canvas.bounds.height)
        templateImageView.contentMode = .scaleAspectFill
        templateImageView.clipsToBounds = true

        canvas.addSubview(templateImageView)
        canvas.sendSubviewToBack(templateImageView)
    }

    func setImageData(_ imageData: String) {
        if imageData.isEmpty || imageData == "" || self.imageData == imageData {
            return
        }
        self.imageData = imageData
    }

    func clearDraw(_ options: CreaDrawOptions) {
        if !options.force {
            let title = NSLocalizedString("確認", comment: "Clear confirmation title")
            let message = NSLocalizedString("描画をクリアしますか？", comment: "Clear confirmation message")
            let okTitle = NSLocalizedString("OK", comment: "OK button")
            let cancelTitle = NSLocalizedString("キャンセル", comment: "Cancel button")

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { _ in
                self.canvas.drawing = PKDrawing()
            }))
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))

            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }

            return
        }

        self.canvas.drawing = PKDrawing()
    }

    func undo() {
        // undoManager?.undo()
    }

    func redo() {
        // undoManager?.redo()
    }

    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        print("canvasViewDidBeginUsingTool")
    }
}

