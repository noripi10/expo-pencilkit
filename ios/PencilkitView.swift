import Foundation
import PencilKit

class PencilkitView: UIView, PKToolPickerObserver, UIGestureRecognizerDelegate, PKCanvasViewDelegate {
    lazy var canvas: PKCanvasView = {
        let canvasView = PKCanvasView()
        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        }
        canvasView.isMultipleTouchEnabled = true
        canvasView.isOpaque = true
        canvasView.backgroundColor = .clear

        return canvasView
    }()

    private let templateImageView = UIImageView()
    private var toolPicker: PKToolPicker?
    private var imageData: String = ""

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
        canvas.becomeFirstResponder()
        canvas.frame = bounds

        createImage()
    }

    func setImageData(_ imageData: String) {
        if imageData.isEmpty || imageData == "" || self.imageData == imageData {
            return
        }
        self.imageData = imageData
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

    func clearDraw() {
        canvas.drawing = PKDrawing()
    }

    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        print("canvasViewDidBeginUsingTool")
    }
}

