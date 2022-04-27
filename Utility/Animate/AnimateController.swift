import UIKit
import SnapKit

class AnimateController: UIViewController {
    //https://ios.devdon.com/archives/358
    //https://www.appcoda.com.tw/custom-view-controller-transitions-tutorial/
    
    var btn: UIButton!
    
    var testAnimateView: UIView!
    var testAnimateView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupButton()
    }
    

}

// MARK: Gesture
extension AnimateController {
    func setupButton() {
        btn.addTarget(self, action: #selector(btnButtonPressed), for: .touchUpInside)
    }
    
    @objc func btnButtonPressed() {
        layerShowImage()
    }
    
    func singleAnimate() {
        let bounds = CABasicAnimation(keyPath: "bounds")
        bounds.fromValue = testAnimateView.bounds
        bounds.toValue = CGRect(x: 0, y: 0, width: 20, height: 20)
        testAnimateView.layer.add(bounds, forKey: nil)
    }
    
    func groupAnimate() {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        groupAnimation.beginTime = CACurrentMediaTime()// + 0.5
        groupAnimation.duration = 0.5
        groupAnimation.fillMode = .both
        
        let bounds = CABasicAnimation(keyPath: "bounds")
        bounds.fromValue = testAnimateView.bounds
        bounds.toValue = CGRect(x: 0, y: 0, width: 20, height: 20)
            
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 3.5
        scaleDown.toValue = 1.0
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = .pi / 4.0
        rotate.toValue = 0.0
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0
        groupAnimation.animations = [bounds, scaleDown, rotate]
        testAnimateView.layer.add(groupAnimation, forKey: nil)
    }
    
    func springAnimate() {
//    damping: 摩擦相关, 默认是10.0
//    mass: 质量，默认是1.0
//    stiffness: 重力相关, 默认是100.0
//    initialVelocity: 初始速度，默认是0.0
        
        
        let flash = CASpringAnimation(keyPath: "bounds")
        flash.beginTime = CACurrentMediaTime()
        flash.damping = 7.0
        flash.stiffness = 200.0
        flash.fromValue = testAnimateView.bounds
        flash.toValue = CGRect(x: 0, y: 0, width: 300, height: 300)
        flash.duration = 3
        
        testAnimateView.layer.add(flash, forKey: nil)
    }
    
    func layerShowImage() {
//    https://zsisme.gitbooks.io/ios-/content/chapter2/the-contents-image.html
        let image = UIImage(named: "default")
        testAnimateView.layer.contents = image?.cgImage
        testAnimateView.layer.contentsGravity = .resizeAspectFill
        
        testAnimateView2.layer.contents = image?.cgImage
        testAnimateView2.layer.contentsGravity = .resizeAspectFill
        testAnimateView2.layer.contentsCenter = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
    }
}

extension AnimateController {
    func setupUI() {
        btn = UIButton()
        btn.forSelf {
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle("transition", for: .normal)
            $0.titleLabel?.font = UIFont.getDefaultFont(.bold, size: 30)
        }
        btn.addTarget(self, action: #selector(btnButtonPressed), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        testAnimateView = UIView()
        testAnimateView.forSelf {
            $0.backgroundColor = .red
        }
        view.addSubview(testAnimateView)
        testAnimateView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(100)
        }
        
        testAnimateView2 = UIView()
        testAnimateView2.forSelf {
            $0.backgroundColor = .red
        }
        view.addSubview(testAnimateView2)
        testAnimateView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.4)
            make.size.equalTo(100)
        }
    }
}
