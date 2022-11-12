import UIKit

class CircleProgressView: UIView {
    let lineWidth: CGFloat
    let circleLayer = CAShapeLayer()
    var current: Double = 0
    var colors = [UIColor]()
    
    init(lineWidth: CGFloat, colors: [UIColor] = [.black, .black]) {
        self.lineWidth = lineWidth
        self.colors = colors
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layout(rect)
    }
    
    func layout(_ rect: CGRect) {
        circleLayer.frame = rect
        circleLayer.position = CGPoint(x: rect.width / 2, y: rect.height / 2)
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: rect.width - lineWidth, height: rect.height - lineWidth)).cgPath
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 1
        circleLayer.lineCap = .round
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.green.cgColor
        circleLayer.transform = CATransform3DRotate(CATransform3DIdentity, -CGFloat(Double.pi / 2), 0, 0, 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0, 1]
        gradientLayer.mask = circleLayer
        layer.addSublayer(gradientLayer)
    }

}

extension CircleProgressView {
    func setPercent(_ percent: Double) {
        self.circleLayer.strokeEnd = percent
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = current
        animation.toValue = percent
        animation.duration = 1.001
        self.circleLayer.add(animation, forKey: nil)
        current = percent
    }
    
    func setShadow(shadowColor: UIColor = .black, shadowOpacity: Double = 0.5, shadowRadius: Double = 3) {
        circleLayer.shadowColor = shadowColor.cgColor
        circleLayer.shadowOpacity = Float(shadowOpacity)
        circleLayer.shadowRadius = shadowRadius
    }
}
