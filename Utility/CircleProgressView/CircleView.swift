import UIKit
import SnapKit
class CircleView: UIView {
    let outsideView = UIView()
    let insideView = UIView()
    let layerView = UIView()
    let pointOutsideView = UIView()
    let pointInsideView = UIView()
    var percentLayer = CAShapeLayer()
    
    var displayLink: CADisplayLink?
    var percent: Double = 0
    let animationDuration = 1.0
    var animationStartDate = Date()
    
    init() {
        super.init(frame: .zero)
        layoutIfNeeded()
        outsideView.backgroundColor = UIColor(0x555555)
        addSubview(outsideView)
        outsideView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        insideView.backgroundColor = UIColor(0x999999)
        addSubview(insideView)
        insideView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.875)
        }
        
        addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.75)
        }
        
        pointOutsideView.backgroundColor = UIColor(0x999999)
        addSubview(pointOutsideView)
        pointOutsideView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.23)
        }
        
        pointInsideView.backgroundColor = UIColor(0x333333)
        addSubview(pointInsideView)
        pointInsideView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.134)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        outsideView.layer.cornerRadius = outsideView.bounds.width / 2
        insideView.layer.cornerRadius = insideView.bounds.width / 2
        pointOutsideView.layer.cornerRadius = pointOutsideView.bounds.width / 2
        pointInsideView.layer.cornerRadius = pointInsideView.bounds.width / 2
    }
}

extension CircleView {
    func setProgress(_ percent: Double) {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        self.percent = percent
        animationStartDate = Date()
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc func handleUpdate() {
        let radius: CGFloat = layerView.frame.width / 2
        let aDegree: Double = Double.pi / 180
        let endDegree = 360 * percent
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            displayLink?.invalidate()
            displayLink = nil
        } else {
            let percentage = elapsedTime / animationDuration
            let value:Double = aDegree * endDegree * percentage
            
            let percentagePath = UIBezierPath()
            percentagePath.move(to: layerView.center)
            percentagePath.addArc(withCenter: layerView.center, radius: radius, startAngle: 0, endAngle: value, clockwise: true)
            percentLayer.removeFromSuperlayer()
            let rect = layerView.frame
            percentLayer = CAShapeLayer()
            percentLayer.frame = rect
            percentLayer.position = CGPoint(x: rect.width / 2 + rect.origin.x, y: rect.height / 2 + rect.origin.y)
            percentLayer.path = percentagePath.cgPath
            percentLayer.fillColor  = UIColor(0xC3FF00).cgColor
            percentLayer.transform = CATransform3DRotate(CATransform3DIdentity, -CGFloat(Double.pi / 2), 0, 0, 1)
            percentLayer.transform = CATransform3DRotate(percentLayer.transform, CGFloat(Double.pi), 1, 0, 0)
            layerView.layer.addSublayer(percentLayer)
        }
    }
}
