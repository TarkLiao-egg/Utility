import UIKit
import SnapKit

class CATextLayerController: UIViewController {
    let rootView = UIView()
    let textLayer = CATextLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction)))
        
        rootView.backgroundColor = .black
        view.addSubview(rootView)
        rootView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textLayer.string = "Text"
        textLayer.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        textLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        textLayer.position = CGPoint(x: 200, y: 200)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = UIScreen.main.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0, 1]
        gradientLayer.mask = textLayer
        rootView.layer.addSublayer(gradientLayer)
        
    }
    
}

extension CATextLayerController {
    
    @objc func panAction(_ recognizer: UIPanGestureRecognizer) {
        let offset = recognizer.location(in: view)
        textLayer.position = offset
        textLayer.layoutIfNeeded()
    }
}
