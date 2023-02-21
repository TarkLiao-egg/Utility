import UIKit


class UIKitDynamicController: UIViewController {
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    override func viewDidLoad() {
        super.viewDidLoad()
        let square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square.backgroundColor = UIColor.gray
        view.addSubview(square)
        
        let label = UILabel()
        label.text = "Hello world"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        let circle = UIView()
        circle.backgroundColor = .red
        circle.layer.cornerRadius = 30
        view.addSubview(circle)
        circle.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.center.equalToSuperview()
        }
        view.layoutIfNeeded()
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square, circle, label])
        animator.addBehavior(gravity)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.98
        animator.addBehavior(itemBehaviour)
        
        let yelloBarrier = UIView(frame: CGRect(x: UIScreen.main.bounds.width - 130, y: 300, width: 130, height: 20))
        yelloBarrier.backgroundColor = UIColor.yellow
        view.addSubview(yelloBarrier)

        
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.red
        view.addSubview(barrier)
        collision = UICollisionBehavior(items: [square, circle, barrier, yelloBarrier, label])
        collision.collisionDelegate = self
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let coll = UIView(frame: CGRect(x: 100, y: 400, width: 130, height: 20))
        coll.backgroundColor = UIColor.blue
        view.addSubview(coll)
        collision.addBoundary(withIdentifier: "coll" as NSCopying, for: UIBezierPath(rect: coll.frame))
    }
}

extension UIKitDynamicController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("Boundary contact occurred - \(identifier)")
        let collidingView = item as! UIView
        collidingView.backgroundColor = UIColor.yellow
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
          collidingView.backgroundColor = UIColor.gray
        }
    }
}
