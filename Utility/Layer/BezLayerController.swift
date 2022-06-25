import UIKit
import SnapKit

class BezLayerController: UIViewController {
    let testMaskView = UIView()
    let testView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.layoutIfNeeded()
        setupMaskLayer()
        setupLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupMaskLayer() {
//        let basicPath = UIBezierPath(rect: view.frame)
//        let basicLayer = CAShapeLayer()
//        basicLayer.path = basicPath.cgPath
//        rectView.layer.addSublayer(basicLayer)
        
        let masklayer = CAShapeLayer()
        masklayer.fillRule = .evenOdd
        
        
        let maskPath = UIBezierPath(ovalIn: CGRect(x: 50, y: 0, width: 50, height: 50)) // 圓型
//        let maskPath = UIBezierPath(rect: CGRect(x: 30, y: 30, width: 100, height: 10)) //自定義的遮罩圖形
//        let newLayer = CAShapeLayer()
//        newLayer.path = basicPath.cgPath
        masklayer.path = maskPath.cgPath
        testMaskView.layer.mask = masklayer
        
    }
    
    func setupLayer() {
        let rect = testView.frame
        let path = UIBezierPath()
        path.lineJoinStyle = .round//设置两条线连结点的样式
        path.lineCapStyle = .square//设置线条拐角帽的样式
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
//        path.stroke() 不close
        path.close()
        let layer = CAShapeLayer()
        layer.fillRule = .nonZero
        layer.path = path.cgPath
        layer.lineWidth = 3
        layer.fillColor = UIColor.green.cgColor
        layer.strokeColor = UIColor.white.cgColor
        
        testView.layer.addSublayer(layer)
    }
}

extension BezLayerController {
    func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(testMaskView)
        testMaskView.alpha = 0.7
        testMaskView.backgroundColor = .red.withAlphaComponent(0.4)
        testMaskView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(testView)
        testView.backgroundColor = .orange.withAlphaComponent(0.4)
        testView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview().multipliedBy(1.5)
        }
    }
}
