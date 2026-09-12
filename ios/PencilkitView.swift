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
        // 描画モード時はscrollView自体のパン/ピンチを止めてcanvasに専念させる
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

    // MARK: - Pan / Zoom

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
