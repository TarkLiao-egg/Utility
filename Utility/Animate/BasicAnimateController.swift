import UIKit
import SnapKit

class BasicAnimateController: UIViewController {
    var colorView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(colorView)
        colorView.backgroundColor = .red
        colorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
        
        let btn = UIButton()
        btn.setTitle("Btn", for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.4)
            make.size.equalTo(30)
        }
        btn.addTarget(self, action: #selector(btnSelector), for: .touchUpInside)
    }
    
    @objc func btnSelector() {
        run()
    }

    func run() {
        let springMoveLeftAnimation = CABasicAnimation(keyPath: "position.x")
        springMoveLeftAnimation.fromValue = -view.frame.width
        springMoveLeftAnimation.toValue = view.frame.width
        springMoveLeftAnimation.duration = 0.7
        springMoveLeftAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        colorView.layer.add(springMoveLeftAnimation, forKey: nil)
    }

}
