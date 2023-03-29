import UIKit
import SnapKit

class CircleDragView: UIView {
    var rect: CGRect = .zero
    var lineWidth: CGFloat = 30
    var colors = [UIColor.black]
    let dot = UIView()
    var lineLayer: CAShapeLayer!
    let moveView = UIView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.rect = rect
        layout(rect)
        
    }
    
    func layout(_ rect: CGRect) {
        outside(rect)
        lineLayer = insideLine(rect)
        
        dot.layer.cornerRadius = 15
        dot.backgroundColor = .yellow
        dot.center = CGPoint(x: 0.5, y: 0.5)
        addSubview(dot)
        dot.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
//        moveView.transform = CGAffineTransform(rotationAngle: -90 * CGFloat.pi/180)
        addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        print(lineLayer.path)
    }
    
    func insideLine(_ rect: CGRect) -> CAShapeLayer {
        let circleView = UIView()
        let lineLayer = CAShapeLayer()
        lineLayer.frame = rect
        lineLayer.position = CGPoint(x: rect.width / 2, y: rect.height / 2)
        lineLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: rect.width, height: rect.height)).cgPath
        lineLayer.lineWidth = 1
        lineLayer.lineCap = .butt
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = UIColor.black.cgColor
        lineLayer.transform = CATransform3DRotate(CATransform3DIdentity, -CGFloat(Double.pi / 2), 0, 0, 1)
        circleView.layer.addSublayer(lineLayer)
        addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return lineLayer
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
    
    func getCirclePoint(x: CGFloat? = nil, y: CGFloat? = nil) -> CGPoint {
        let centerX: CGFloat = rect.width / 2
        let centerY: CGFloat = rect.width / 2
        let radius: CGFloat = rect.width / 2
        if let x = x {
            var angleInRadians: CGFloat = 0
            if x >= centerX {
                angleInRadians = acos((x - centerX) / radius)
            } else {
                angleInRadians = 2 * CGFloat.pi + acos((x - centerX) / radius)
            }
            let y = centerY + radius * sin(angleInRadians)
            return CGPoint(x: x, y: y)
        } else if let y = y {
            var angleInRadians: CGFloat = 0
            if y >= centerY {
                angleInRadians = asin((y - centerY) / radius)
            } else {
                angleInRadians = 2 * CGFloat.pi - asin((y - centerY) / radius)
            }
            let x = centerX + radius * cos(angleInRadians)
            return CGPoint(x: x, y: y)
        }
        return .zero
    }
    
    func checkPoint(_ point: CGPoint) -> CGPoint {
        var point = point
        if point.x > rect.width {
            point.x = rect.width
        } else if point.x < 0 {
            point.x = 0
        }
        
        if point.y > rect.height {
            point.y = rect.height
        } else if point.y < 0 {
            point.y = 0
        }
        return point
    }
    
    func touchToPoint(_ touches: Set<UITouch>) -> CGPoint {
        guard let touch = touches.first else { return .zero }
        let point = touch.location(in: self)
        let newPoint = checkPoint(point)
        
        
        return newPoint
    }
    
    func choosePoint(_ point: CGPoint) -> CGPoint {
        let centerX: CGFloat = rect.width / 2
        let centerY: CGFloat = rect.width / 2
        let pointOnArcFromX = getCirclePoint(x: point.x)
        var pointOnArcX = pointOnArcFromX
        if point.y < centerY {
            let temp = pointOnArcX.y - centerY
            pointOnArcX.y = centerY - temp
        }
        
        
        let pointOnArcFromY = getCirclePoint(y: point.y)
        var pointOnArcY = pointOnArcFromY
        if point.x < centerX {
            let temp = pointOnArcY.x - centerX
            pointOnArcY.x = centerX - temp
        }
        
        let distanceX = sqrt(pow(abs(point.x - pointOnArcX.x), 2) + pow(abs(point.y - pointOnArcX.y), 2))
        let distanceY = sqrt(pow(abs(point.x - pointOnArcY.x), 2) + pow(abs(point.y - pointOnArcY.y), 2))
        return distanceX < distanceY ? pointOnArcX : pointOnArcY
//        if distanceX > distanceY {
//            let pointOnArcFromX = getCirclePoint(x: point.x)
//            var pointOnArc = pointOnArcFromX
//            if point.y < centerY {
//                let temp = pointOnArc.y - centerY
//                pointOnArc.y = centerY - temp
//            }
//            return pointOnArc
//        } else {
//            let pointOnArcFromY = getCirclePoint(y: point.y)
//            var pointOnArc = pointOnArcFromY
//            if point.x < centerX {
//                let temp = pointOnArc.x - centerX
//                pointOnArc.x = centerX - temp
//            }
//            return pointOnArc
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touchToPoint(touches)
        
        let pointOnArc = choosePoint(point)
        dot.snp.remakeConstraints { make in
            make.size.equalTo(30)
            make.top.equalToSuperview().inset(pointOnArc.y - 15)
            make.leading.equalToSuperview().inset(pointOnArc.x - 15)
        }
        
//        let centerX: CGFloat = rect.width / 2
//        let centerY: CGFloat = rect.width / 2
//        let radius: CGFloat = rect.width / 2
//        let angleInDegrees: CGFloat = 90
//
//        // 将角度转换为弧度
//        let angleInRadians = angleInDegrees * CGFloat.pi / 180.0
//        print(angleInRadians)
//        // 计算圆弧上点的坐标
//        let x = centerX + radius * cos(angleInRadians)
//        let y = centerY + radius * sin(angleInRadians)
//        print(x)
//        let ddd = acos((x - centerX) / radius)
//        print(ddd)
//        let ddd2 = 2 * CGFloat.pi - acos((x - centerX) / radius)
//        print(ddd2)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touchToPoint(touches)
        
        let pointOnArc = choosePoint(point)
        dot.snp.remakeConstraints { make in
            make.size.equalTo(30)
            make.top.equalToSuperview().inset(pointOnArc.y - 15)
            make.leading.equalToSuperview().inset(pointOnArc.x - 15)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("cancel")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touchToPoint(touches)
        
        let pointOnArc = choosePoint(point)
        dot.snp.remakeConstraints { make in
            make.size.equalTo(30)
            make.top.equalToSuperview().inset(pointOnArc.y - 15)
            make.leading.equalToSuperview().inset(pointOnArc.x - 15)
        }
        
    }
}
