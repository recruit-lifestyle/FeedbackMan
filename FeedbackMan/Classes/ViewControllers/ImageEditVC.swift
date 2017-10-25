import Foundation
import UIKit

final class ImageEditVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageEditView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var screenshotImageView: UIImageView!
    @IBOutlet weak var sliderValue: UISlider!
    
    @IBAction func changeColors(_ sender: UIButton) {
        guard let color = sender.currentTitle else {
            return
        }
        switch color {
        case "Black":
            drawColor = .black
            ovalShapeLayer.fillColor = drawColor.cgColor
        case "Blue":
            drawColor = .blue
            ovalShapeLayer.fillColor = drawColor.cgColor
        case "Red":
            drawColor = .red
            ovalShapeLayer.fillColor = drawColor.cgColor
        case "Green":
            drawColor = .green
            ovalShapeLayer.fillColor = drawColor.cgColor
        case "White":
            drawColor = .white
            ovalShapeLayer.fillColor = drawColor.cgColor
        case "Purple":
            drawColor = .purple
            ovalShapeLayer.fillColor = drawColor.cgColor
        case "Orange":
            drawColor = .orange
            ovalShapeLayer.fillColor = drawColor.cgColor
        case "Yellow":
            drawColor = .yellow
            ovalShapeLayer.fillColor = drawColor.cgColor
        default:
            break
        }
    }
    
    @IBAction func onPressedUndo(_ sender: Any) {
        if currentDrawNumber > 0 {
            self.screenshotImageView.image = savedImageArray[currentDrawNumber - 1]
            currentDrawNumber -= 1
        }
    }
    
    @IBAction func onPressedRedo(_ sender: Any) {
        if currentDrawNumber + 1 < savedImageArray.count {
            self.screenshotImageView.image = savedImageArray[currentDrawNumber + 1]
            currentDrawNumber += 1
        }
    }
    
    @IBAction func onPressedDone(_ sender: Any) {
        let vc = self.presentingViewController as! ModalVC
        vc.screenshotImageView.image = self.screenshotImageView.image
        vc.screenshotImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func slideSlider(_ sender: Any) {
        lineWidth = CGFloat(sliderValue.value) * scale
        ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 300 - lineWidth!, y: 90 - lineWidth!, width: lineWidth!*2, height: lineWidth!*2)).cgPath
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var lastPoint: CGPoint?
    var lineWidth: CGFloat?
    var drawColor = UIColor()
    var bezierPath: UIBezierPath?
    var savedImageArray = [UIImage]()
    var currentDrawNumber = 0
    let scale: CGFloat = 15
    let ovalShapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        prepareDrawing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedImageArray.append(self.screenshotImageView.image!)
    }
    
    private func prepareDrawing() {
        let myDraw = UIPanGestureRecognizer(target: self, action: #selector(ImageEditVC.drawGesture(_:)))
        myDraw.maximumNumberOfTouches = 1
        drawColor = UIColor.blue
        lineWidth = CGFloat(sliderValue.value) * scale
        self.scrollView.addGestureRecognizer(myDraw)
        
        ovalShapeLayer.strokeColor = UIColor.lightGray.cgColor
        ovalShapeLayer.fillColor = drawColor.cgColor
        ovalShapeLayer.lineWidth = 0.5
        ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 300 - lineWidth!, y: 90 - lineWidth!, width: lineWidth!*2, height: lineWidth!*2)).cgPath
        view.layer.addSublayer(ovalShapeLayer)
        prepareCanvas()
    }
    
    func prepareCanvas() {
        let canvasSize = CGSize(width: view.frame.width * 2, height: view.frame.width * 2)
        let canvasRect = CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        var firstCanvasImage = UIImage()
        UIColor.white.setFill()
        UIRectFill(canvasRect)
        firstCanvasImage.draw(in: canvasRect)
        firstCanvasImage = UIGraphicsGetImageFromCurrentImageContext()!
        screenshotImageView.contentMode = .scaleAspectFit
        screenshotImageView.image = firstCanvasImage
        UIGraphicsEndImageContext()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.screenshotImageView
    }
    
    func drawGesture(_ sender: Any) {
        guard let drawGesture = sender as? UIPanGestureRecognizer else {
            print("drawGesture Error happened.")
            return
        }
        
        guard let canvas = self.screenshotImageView.image else {
            fatalError("self.pictureView.image not found")
        }
            
        let touchPoint = drawGesture.location(in: screenshotImageView)
        
        switch drawGesture.state {
        case .began:
            lastPoint = touchPoint
            let lastPointForCanvasSize = convertPointForCanvasSize(originalPoint: lastPoint!, canvasSize: canvas.size)
            
            bezierPath = UIBezierPath()
            guard let bzrPath = bezierPath else {
                fatalError("bazierPath Error")
            }
            bzrPath.lineCapStyle = .round
            bzrPath.lineWidth = lineWidth!
            bzrPath.move(to: lastPointForCanvasSize)
            
        case .changed:
            let newPoint = touchPoint
            guard let brzPath = bezierPath else {
                fatalError("bezierPath Error")
            }
            let imageAfterDraw = drawGestureAtChanged(canvas: canvas, lastPoint: lastPoint!, newPoint: newPoint, bezierPath: brzPath)
            self.screenshotImageView.image = imageAfterDraw
            lastPoint = newPoint
            
        case .ended:
            while currentDrawNumber != savedImageArray.count - 1 {
                savedImageArray.removeLast()
            }
            
            currentDrawNumber += 1
            savedImageArray.append(self.screenshotImageView.image!)
            
            if currentDrawNumber != savedImageArray.count - 1 {
                fatalError("index Error")
            }
            
        default:
            ()
        }
    }
    
    func drawGestureAtChanged(canvas: UIImage, lastPoint: CGPoint, newPoint: CGPoint, bezierPath: UIBezierPath) -> UIImage {
        let middlePoint = CGPoint(x: (lastPoint.x + newPoint.x) / 2, y: (lastPoint.y + newPoint.y) / 2)
        
        let middlePointForCanvas = convertPointForCanvasSize(originalPoint: middlePoint, canvasSize: canvas.size)
        let lastPointForCanvas = convertPointForCanvasSize(originalPoint: lastPoint, canvasSize: canvas.size)
        
        bezierPath.addQuadCurve(to: middlePointForCanvas, controlPoint: lastPointForCanvas)
        UIGraphicsBeginImageContextWithOptions(canvas.size, false, 0.0)
        let canvasRect = CGRect(x: 0, y: 0, width: canvas.size.width, height: canvas.size.height)
        self.screenshotImageView.image?.draw(in: canvasRect)
        drawColor.setStroke()
        bezierPath.stroke()
        let imageAfterDraw = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageAfterDraw!
    }
    
    func convertPointForCanvasSize(originalPoint: CGPoint, canvasSize: CGSize) -> CGPoint {
        let viewSize = scrollView.frame.size
        var ajustContextSize = canvasSize
        var diffSize: CGSize = CGSize(width: 0, height: 0)
        let viewRatio = viewSize.width / viewSize.height
        let contextRatio = canvasSize.width / canvasSize.height
        let isWidthLong = viewRatio < contextRatio ? true : false
        
        if isWidthLong {
            ajustContextSize.height = ajustContextSize.width * viewSize.height / viewSize.width
            diffSize.height = (ajustContextSize.height - canvasSize.height) / 2
        } else {
            ajustContextSize.width = ajustContextSize.height * viewSize.width / viewSize.height
            diffSize.width = (ajustContextSize.width - canvasSize.width) / 2
        }
        
        let convertPoint = CGPoint(x: originalPoint.x * ajustContextSize.width / viewSize.width - diffSize.width, y: originalPoint.y * ajustContextSize.height / viewSize.height - diffSize.height)
        
        return convertPoint
    }
}
