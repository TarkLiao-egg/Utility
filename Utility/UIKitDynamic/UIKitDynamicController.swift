import UIKit


class UIKitDynamicController: UIViewController {
    var helloLabel: UILabel!
    var circleView: UIView!
    var squareView: UIView!
    var yelloBarrier: UIView!
    var redbarrier: UIView!
    
    var animator: UIDynamicAnimator!
    var itemBehaviour: UIDynamicItemBehavior!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var snap: UISnapBehavior!
    var firstContact = false
    var startPoint = CGPoint.zero
    override func viewDidLoad() {
        super.viewDidLoad()
        squareView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        squareView.backgroundColor = UIColor.gray
        view.addSubview(squareView)
        
        helloLabel = UILabel()
        helloLabel.text = "Hello world"
        helloLabel.textColor = .white
        helloLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.addSubview(helloLabel)
        helloLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        circleView = UIView()
        circleView.backgroundColor = .red
        circleView.layer.cornerRadius = 30
        view.addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.center.equalToSuperview()
        }
        view.layoutIfNeeded()
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [squareView, circleView, helloLabel])
        gravity.gravityDirection = CGVector(dx: 0, dy: 1)
        animator.addBehavior(gravity)
        
        itemBehaviour = UIDynamicItemBehavior(items: [squareView])
        itemBehaviour.elasticity = 0.8
//        elasticity 彈性 – determines how ‘elastic’ collisions will be, i.e. how bouncy or ‘rubbery’ the item behaves in collisions.
//        friction 摩擦力 – determines the amount of resistance to movement when sliding along a surface.
//        density 質量 – when combined with size, this will give the overall mass of an item. The greater the mass, the harder it is to accelerate or decelerate an object.
//        resistance 阻力 – determines the amount of resistance to any linear movement. This is in contrast to friction, which only applies to sliding movements.
//        angularResistance 旋轉阻力 – determines the amount of resistance to any rotational movement.
//        allowsRotation 旋轉 – this is an interesting one that doesn’t model any real-world physics property. With this property set to NO the object will not rotate at all, regardless of any rotational forces that occur.
        animator.addBehavior(itemBehaviour)
        
        yelloBarrier = UIView(frame: CGRect(x: UIScreen.main.bounds.width - 130, y: 300, width: 130, height: 20))
        yelloBarrier.backgroundColor = UIColor.yellow
        view.addSubview(yelloBarrier)

        
        redbarrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        redbarrier.backgroundColor = UIColor.red
        view.addSubview(redbarrier)
        collision = UICollisionBehavior(items: [squareView, circleView, redbarrier, yelloBarrier, helloLabel])
        collision.collisionDelegate = self
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let coll = UIView(frame: CGRect(x: 0, y: 400, width: 130, height: 20))
        coll.backgroundColor = UIColor.blue
        view.addSubview(coll)
        collision.addBoundary(withIdentifier: "coll" as NSCopying, for: UIBezierPath(rect: coll.frame))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {[unowned self] in
            gravity.addItem(redbarrier)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {[unowned self] in
            gravity.removeItem(redbarrier)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            print("左側力量")
            let gravityField = UIFieldBehavior.linearGravityField(direction: CGVector(dx: -30, dy: 0))
            // 设置重力场的强度
            gravityField.strength = 1.0
            gravityField.addItem(yelloBarrier)
            // 将重力场添加到物理仿真引擎中
            animator.addBehavior(gravityField)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
//            print("自定義重力場")
//            let gravityField = UIFieldBehavior.radialGravityField(position: CGPoint(x: -10, y: -20))
//            gravityField.strength = 1.0
//            gravityField.addItem(yelloBarrier)
//            animator.addBehavior(gravityField)
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            print("推力")
            let pushBehavior = UIPushBehavior(items: [redbarrier], mode: .instantaneous)
            animator.addBehavior(pushBehavior)

            // 施加推力
            pushBehavior.setAngle(0, magnitude: 1.0)
            pushBehavior.active = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        startPoint = touch.location(in: view)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let newPoint = CGPoint(x: 4 * (touch.location(in: view).x - startPoint.x), y: 4 * (touch.location(in: view).y - startPoint.y))
        itemBehaviour.addItem(touch.view!)
        itemBehaviour.addLinearVelocity(newPoint, for: touch.view!)
        
        print("用于将物体快速吸附到指定位置")
        snap = UISnapBehavior(item: touch.view!, snapTo: touch.location(in: view))
        animator.addBehavior(snap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[unowned self] in
            animator.removeBehavior(snap)
        }
    }
}

extension UIKitDynamicController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {

        let collidingView = item as! UIView
        
        if collidingView == helloLabel {
            print("helloLabel contact with wall \(identifier)")
        } else if collidingView == circleView {
            print("circleView contact with wall \(identifier)")
        } else if collidingView == squareView {
            print("squareView contact with wall \(identifier)")
        } else if collidingView == yelloBarrier {
            print("yelloBarrier contact with wall \(identifier)")
        } else if collidingView == redbarrier {
            print("redbarrier contact with wall \(identifier)")
        }
//        collidingView.backgroundColor = UIColor.yellow
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
//          collidingView.backgroundColor = UIColor.gray
//        }
//        setAttachment(collidingView)
    }
    
    func setAttachment(_ collidingView: UIView) {
        //連接器
        if (!firstContact) {
            firstContact = true

            let square = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 100))
            square.backgroundColor = UIColor.gray
            view.addSubview(square)

            collision.addItem(square)
            gravity.addItem(square)
            
            let attach = UIAttachmentBehavior(item: collidingView, attachedTo:square)
            attach.length = 50
            animator.addBehavior(attach)
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        let collidingView = item1 as! UIView
        let collidingView2 = item2 as! UIView
        var coll1: String = ""
        if collidingView == helloLabel {
            coll1 = "helloLabel"
        } else if collidingView == circleView {
            coll1 = "circleView"
        } else if collidingView == squareView {
            coll1 = "squareView"
        } else if collidingView == yelloBarrier {
            coll1 = "yelloBarrier"
        } else if collidingView == redbarrier {
            coll1 = "redbarrier"
        }
        var coll2: String = ""
        if collidingView2 == helloLabel {
            coll2 = "helloLabel"
        } else if collidingView2 == circleView {
            coll2 = "circleView"
        } else if collidingView2 == squareView {
            coll2 = "squareView"
        } else if collidingView2 == yelloBarrier {
            coll2 = "yelloBarrier"
        } else if collidingView2 == redbarrier {
            coll2 = "redbarrier"
        }
        print("\(coll1) contact with \(coll2)")
    }
}
