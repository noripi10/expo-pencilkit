import Foundation
import PencilKit

class PencilkitView: UIView, PKToolPickerObserver, UIGestureRecognizerDelegate, PKCanvasViewDelegate, UIScrollViewDelegate {
    private let templateImageView = UIImageView()
    private var imageData: String = ""

    private var toolPicker: PKToolPicker?

    private var isPanZoomMode = false

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.bouncesZoom = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        // 描画モード時はscrollView自体のパン/ピンチを止める
        scrollView.isScrollEnabled = false
        scrollView.pinchGestureRecognizer?.isEnabled = false
        return scrollView
    }()

    // ズーム対象となるコンテナ。この中の背景画像と描画がまとめて拡大縮小される
    private let contentView = UIView()

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

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true

        scrollView.delegate = self
        addSubview(scrollView)

        contentView.addSubview(templateImageView)
        contentView.addSubview(canvas)
        scrollView.addSubview(contentView)

        showToolPicker()
    }

    required init?(coder: NSCoder) {
        fatalError("Coder init has not been implemented yet")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        canvas.delegate = self

        scrollView.frame = bounds

        // 初回、もしくはサイズが変わった場合のみコンテンツサイズを再計算する
        // (ズーム中に呼ばれてもcontentViewのframeを壊さないようにするため)
        if contentView.frame.size != bounds.size {
            contentView.frame = CGRect(origin: .zero, size: bounds.size)
            scrollView.contentSize = contentView.frame.size
        }

        canvas.frame = contentView.bounds
        canvas.becomeFirstResponder()

        createImage()
    }

    func showToolPicker() {
        if #available(iOS 14.0, *) {
            toolPicker = PKToolPicker()
            toolPicker?.addObserver(canvas)
            toolPicker?.setVisible(true, forFirstResponder: canvas)
        }
    }

    func createImage() {
        guard let data = Data(base64Encoded: self.imageData) else {
            return
        }
        let image = UIImage(data: data)
        templateImageView.image = image

        templateImageView.frame = contentView.bounds
        templateImageView.contentMode = .scaleAspectFill
        templateImageView.clipsToBounds = true

        contentView.sendSubviewToBack(templateImageView)
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
      canvas.undoManager?.undo()
    }

    func redo() {
      canvas.undoManager?.redo()
    }

    func setRulerActive(_ active: Bool) {
        if #available(iOS 14.0, *) {
            toolPicker?.isRulerActive = active
        }
    }

    // templateImageView の contentMode(.scaleAspectFill) と同じ見た目になるよう、
    // 画像のアスペクト比を保ったまま bounds を覆う矩形を計算する（はみ出た部分は自然にクリップされる）
    private func aspectFillRect(for imageSize: CGSize, in bounds: CGRect) -> CGRect {
        guard imageSize.width > 0, imageSize.height > 0 else { return bounds }

        let scale = max(bounds.width / imageSize.width, bounds.height / imageSize.height)
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale

        return CGRect(
            x: bounds.midX - scaledWidth / 2,
            y: bounds.midY - scaledHeight / 2,
            width: scaledWidth,
            height: scaledHeight
        )
    }

    func exportImage() throws -> ExportImageResult {
        let bounds = canvas.bounds

        // レイアウト前など、canvas がまだ有効なサイズを持っていない場合はエラーにする
        // （UIGraphicsImageRenderer はサイズ0以下の bounds を扱えないため）
        guard bounds.width > 0, bounds.height > 0 else {
            throw ExportImageError.viewNotReady
        }

        // 背景画像 + 描画内容を1枚に合成
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let composedImage = renderer.image { context in
            // 背景（既存の画像データがあれば、画面表示と同じ scaleAspectFill で描画）
            if let templateImage = templateImageView.image {
                let fillRect = aspectFillRect(for: templateImage.size, in: bounds)
                templateImage.draw(in: fillRect)
            }

            // PKDrawingをUIImageとして描画（devicePixelScaleで高解像度に）
            let drawingImage = canvas.drawing.image(from: bounds, scale: UIScreen.main.scale)
            drawingImage.draw(in: bounds)
        }

        guard let pngData = composedImage.pngData() else {
            throw ExportImageError.encodingFailed
        }

        let fileName = "\(UUID().uuidString).png"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try pngData.write(to: fileURL)

        let base64 = pngData.base64EncodedString()

        var result = ExportImageResult()
        result.path = fileURL.path
        result.base64 = base64
        return result
    }

    func setPanZoomMode(_ enabled: Bool) {
        isPanZoomMode = enabled

        // 描画モード <-> パン/ズームモードでタッチの受け手を切り替える
        canvas.isUserInteractionEnabled = !enabled
        scrollView.isScrollEnabled = enabled
        scrollView.pinchGestureRecognizer?.isEnabled = enabled

        if !enabled {
            canvas.becomeFirstResponder()
        }
    }

    func resetZoom() {
        scrollView.setZoomScale(1.0, animated: true)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }

    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        print("canvasViewDidBeginUsingTool")
    }
}

enum ExportImageError: LocalizedError {
    case encodingFailed
    case viewNotReady

    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to encode the exported image as PNG."
        case .viewNotReady:
            return "The canvas view is not ready to export an image yet."
        }
    }
}