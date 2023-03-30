import UIKit
import SnapKit

class CircleDragView: UIView {
    var rect: CGRect = .zero
    var lineWidth: CGFloat = 30
    var colors = [UIColor.black]
    let dot = UIView()
    let moveView = UIView()
    var degreeLayers = [CAShapeLayer]()
    var startRadians: CGFloat = 0
    var endRadians: CGFloat = 0
    var centerX: CGFloat = 0
    var centerY: CGFloat = 0
    var radius: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.rect = rect
        
        centerX = rect.width / 2
        centerY = rect.height / 2
        radius = rect.width / 2 - lineWidth / 2
        
        layout(rect)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchToMoveAction(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchToMoveAction(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchToMoveAction(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchToMoveAction(touches)
    }
}
 
extension CircleDragView {
    // 度數轉弧度
    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180.0
    }

    // 弧度轉度數
    func radiansToDegrees(_ radians: CGFloat) -> CGFloat {
        return radians * 180.0 / .pi
    }
    
    func layout(_ rect: CGRect) {
        outside(rect)
        
        moveView.transform = CGAffineTransform(rotationAngle: -90 * CGFloat.pi/180)
        addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dot.layer.cornerRadius = 15
        dot.backgroundColor = .yellow
        dot.center = CGPoint(x: 0.5, y: 0.5)
        moveView.addSubview(dot)
        dot.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        for i in 0..<360 {
            let path = UIBezierPath()
            let center = CGPoint(x: centerX, y: centerY)
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius + 50, startAngle: degreesToRadians(CGFloat(i)), endAngle: degreesToRadians(CGFloat(i) + 1), clockwise: true)
            path.addLine(to: center)
            path.close()
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 2.0
            moveView.layer.addSublayer(shapeLayer)
            degreeLayers.append(shapeLayer)
        }
    }
    
    func outside(_ rect: CGRect) {
        let circleView = UIView()
        let circleLayer = CAShapeLayer()
        circleLayer.frame = rect
        circleLayer.position = CGPoint(x: rect.width / 2, y: rect.height / 2)
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: rect.width - lineWidth, height: rect.height - lineWidth)).cgPath
        circleLayer.lineWidth = lineWidth
        circleLayer.lineCap = .butt
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.transform = CATransform3DRotate(CATransform3DIdentity, -CGFloat(Double.pi / 2), 0, 0, 1)
        circleView.layer.addSublayer(circleLayer)
        addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func touchToMoveAction(_ touches: Set<UITouch>) {
        let touchPoint = touchToPoint(touches)
        let radians = getRadians(touchPoint)
        let circlePoint = getCirclePoint(radians)
        dragPointAction(circlePoint)
    }
    
    func touchToPoint(_ touches: Set<UITouch>) -> CGPoint {
        guard let touch = touches.first else { return .zero }
        return touch.location(in: moveView)
    }
    
    func getRadians(_ point: CGPoint) -> CGFloat {
        var index: CGFloat = 0
        for (i, degreeLayer) in degreeLayers.enumerated() {
            if degreeLayer.path!.contains(point) {
                index = CGFloat(i)
                break
            }
        }
        return degreesToRadians(index)
    }
    
    func getCirclePoint(_ radians: CGFloat) -> CGPoint {
        let x = centerX + radius * cos(radians)
        let y = centerY + radius * sin(radians)
        return CGPoint(x: x, y: y)
    }
    
    func dragPointAction(_ point: CGPoint) {
        dot.snp.remakeConstraints { make in
            make.size.equalTo(lineWidth)
            make.top.equalToSuperview().inset(point.y - lineWidth / 2)
            make.leading.equalToSuperview().inset(point.x - lineWidth / 2)
        }
    }
}
