import UIKit
import SnapKit
class ReplicatorLayerController: UIViewController {
    var insertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        insertView = UIView()
        insertView.backgroundColor = .gray
        view.addSubview(insertView)
        insertView.snp.makeConstraints { make in
            make.size.equalTo(300)
            make.center.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLayer(view: insertView)
    }
    
    func degreeToRadians(deg: CGFloat) -> CGFloat {
        return (deg * CGFloat.pi) / 180
    }

    func setLayer(view: UIView) {
        let replicator: CAReplicatorLayer = CAReplicatorLayer()
        replicator.frame = view.bounds
        replicator.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(replicator)

        //configure the replicator
        replicator.instanceCount = 18
        replicator.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        print(replicator.position)

        //apply a transform for each instance
        var transform: CATransform3D = CATransform3DIdentity
//        transform = CATransform3DTranslate(transform, 0, 50, 0)
        
        transform = CATransform3DRotate(transform, degreeToRadians(deg: 360 / 18), 0, 0, 1)
//        transform = CATransform3DTranslate(transform, 0, -200, 0)
        replicator.instanceTransform = transform

        //apply a color shift for each instance
//        replicator.instanceBlueOffset = -0.1
//        replicator.instanceGreenOffset = -0.1

        //create a sublayer and place it inside the replicator
        
        let layer = CALayer()
        layer.contents = UIImage(named: "default")?.cgImage
        layer.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.148, height: view.frame.height * 0.148)
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.7
        replicator.addSublayer(layer)
    }

}
