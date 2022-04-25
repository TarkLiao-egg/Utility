import UIKit

class Rotate3DController: UIViewController {
    
    let transformLayer = CATransformLayer()
    var currentAngle: CGFloat = 0
    var currentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        transformLayer.frame = view.bounds
        view.layer.addSublayer(transformLayer)
        
        for i in 0...6 {
            addImageCard(name: String(i))
        }
        turnCarousel()
        setupGesture()
    }
    
    func degreeToRadians(deg: CGFloat) -> CGFloat {
        return (deg * CGFloat.pi) / 180
    }
}

extension Rotate3DController {
    func addImageCard(name: String) {
        let imageSize = CGSize(width: 200, height: 200)
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: view.frame.size.width / 2 - imageSize.width / 2, y: view.frame.size.width / 2 - imageSize.width / 2, width: imageSize.width, height: imageSize.height)
        imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        imageLayer.contents = UIImage(named: "bead_\(name)")?.cgImage
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.masksToBounds = true
        imageLayer.isDoubleSided = true
        transformLayer.addSublayer(imageLayer)
    }
}

extension Rotate3DController {
    func setupGesture() {
        view .addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(_:))))
    }
    
    @objc func panGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        let xOffset = recognizer.translation(in: view).x
        if recognizer.state == .began {
            currentOffset = 0
        }
        
        let xDiff = xOffset * 0.6 - currentOffset
        currentOffset += xDiff
        currentAngle += xDiff
        turnCarousel()
    }
    
    func turnCarousel() {
        guard let transformSublayers = transformLayer.sublayers else { return }
        
        let segment = CGFloat(360 / transformSublayers.count)
        var angleOffset = currentAngle
        for layer in transformSublayers {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            transform = CATransform3DRotate(transform, degreeToRadians(deg: angleOffset), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            
            CATransaction.setAnimationDuration(0)
            layer.transform = transform
            
            angleOffset += segment
        }
    }
}
