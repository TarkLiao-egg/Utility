import UIKit

class DonutView: UIView {
    let lineWidth: CGFloat
    var current: Double = 0
    var colors = [UIColor]()
    let percents: [Double]
    var circles = [CAShapeLayer]()
    var views = [UIView]()
    let centerView = UIView()
    var rect: CGRect = .zero
    
    init(lineWidth: CGFloat, colors: [UIColor] = [UIColor(0xFFB1B1), UIColor(0xDBFFAD), UIColor(0xFFEA9E)], percents: [Double] = [0.3, 0.1, 0.6]) {
        self.lineWidth = lineWidth
        self.colors = colors
        self.percents = percents
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.rect = rect
        layout(rect)
        
    }
    
    func layout(_ rect: CGRect) {
        refresh()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        if let color = self.pixelColor(at: touchPoint) {
            for (i, col) in colors.enumerated() {
                print(col)
                print(color)
                if col == color {
                    setShadow(i)
                    return
                }
            }
        }
        setShadow(percents.count)
    }
    
    func refresh() {
        var currentPercent: Double = 0
        for (i, percent) in percents.enumerated() {
            let circleView = UIView()
            let circleLayer = CAShapeLayer()
            circleLayer.frame = rect
            circleLayer.position = CGPoint(x: rect.width / 2, y: rect.height / 2)
            circleLayer.path = UIBezierPath(ovalIn: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: rect.width - lineWidth, height: rect.height - lineWidth)).cgPath
            circleLayer.lineWidth = lineWidth
            circleLayer.strokeStart = currentPercent
            circleLayer.strokeEnd = currentPercent + percent
            circleLayer.lineCap = .butt
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = colors[i].cgColor
            circleLayer.transform = CATransform3DRotate(CATransform3DIdentity, -CGFloat(Double.pi / 2), 0, 0, 1)
            circles.append(circleLayer)
            
            circleView.layer.addSublayer(circleLayer)
            addSubview(circleView)
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            circleView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            views.append(circleView)
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = currentPercent
            animation.toValue = currentPercent + percent
            animation.duration = 1.001
            circleLayer.add(animation, forKey: nil)
            
            currentPercent += percent
            
        }
    }
    
    func setShadow(_ i: Int) {
        for (index, circle) in circles.enumerated() {
            circle.shadowColor = index == i ? UIColor.black.cgColor : UIColor.clear.cgColor
            circle.shadowOpacity = index == i ? Float(0.5) : 0
            circle.shadowRadius = 3
            circle.lineWidth = lineWidth * (index == i ? 1.4 : 1)
            if index == i {
                bringSubviewToFront(views[index])
            }
        }
    }
    
    func pixelColor(at point: CGPoint) -> UIColor? {
        
        guard let image = toImage(self, point), let inputImage = CIImage(image: image) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
    func toImage(_ view: UIView, _ point: CGPoint) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: -point.x, y: -point.y)
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    func clearLayer() {
        for circle in circles {
            circle.removeFromSuperlayer()
        }

        for view in views {
            view.removeFromSuperview()
        }
        circles = []
        views = []
    }
}
