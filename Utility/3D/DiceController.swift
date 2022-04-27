import UIKit
import SnapKit
class DiceController: UIViewController {

    var diceView: UIView!
    var angle: CGPoint = .zero
    
    var layers = [CALayer]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        diceView = UIView()
//        diceView.backgroundColor = .clear
//        view.addSubview(diceView)
//        diceView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.size.equalTo(150)
//        }
//        addDice()
        setupGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        addDice()
//        setClick()
        
        addDiceLayer()
        for layer in layers {
            print(layer.frame)
        }
    }
    
    func setClick() {
        for subview in diceView.subviews {
            subview.isUserInteractionEnabled = true
            subview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickButtonPressed(_:))))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: diceView), let layers = diceView.layer.sublayers {
            print("\n")
            for (i, layer) in layers.enumerated() {
                if let touchLayer = layer.hitTest(point), touchLayer == layer {
                    print("\(i), \(layer.frame)")
                    print(diceView.layer.superlayer == layer.presentation())
                    
                    
                }
//                    if layer.contains(convert) {
//                        print(i)
//                    }
            }
        }
    }
    
    @objc func clickButtonPressed(_ sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        
    }
    
    func degreeToRadians(deg: CGFloat) -> CGFloat {
        return (deg * CGFloat.pi) / 180
    }
    
    func addDiceLayer() {
        let size: CGFloat = 150
        let viewFrame = UIScreen.main.bounds
        var diceTransform = CATransform3DIdentity
        diceView.frame = CGRect(x: 0, y: viewFrame.maxY / 2 - (size / 2), width: viewFrame.width, height: size)
        
        //1
        let dice1 = CALayer()
        dice1.name = "0"
        dice1.contents = UIImage(named: "bc_0")?.cgImage
        dice1.contentsGravity = .resizeAspectFill
        dice1.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size)
        dice1.transform = diceTransform
        
        //2
        let dice2 = CALayer()
        dice2.contents = UIImage(named: "bc_1")?.cgImage
        dice2.contentsGravity = .resizeAspectFill
        dice2.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 90), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size)
        dice2.transform = diceTransform
        
        //3
        let dice3 = CALayer()
        dice3.contents = UIImage(named: "bc_2")?.cgImage
        dice3.contentsGravity = .resizeAspectFill
        dice3.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 180), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size)
        dice3.transform = diceTransform
        
//        //4
        let dice4 = CALayer()
        dice4.contents = UIImage(named: "bc_3")?.cgImage
        dice4.contentsGravity = .resizeAspectFill
        dice4.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 270), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size)
        dice4.transform = diceTransform
//
//        //5
        let dice5 = CALayer()
        dice5.contents = UIImage(named: "bc_4")?.cgImage
        dice5.contentsGravity = .resizeAspectFill
        dice5.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 90), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size)
        dice5.transform = diceTransform
//
//        //6
        let dice6 = CALayer()
        dice6.contents = UIImage(named: "bc_5")?.cgImage
        dice6.contentsGravity = .resizeAspectFill
        dice6.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 270), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size)
        dice6.transform = diceTransform
        diceView.layer.addSublayer(dice1)
        diceView.layer.addSublayer(dice2)
        diceView.layer.addSublayer(dice3)
        diceView.layer.addSublayer(dice4)
        diceView.layer.addSublayer(dice5)
        diceView.layer.addSublayer(dice6)
//        dice1.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        view.addSubview(diceView)
        
        layers.append(dice1)
        layers.append(dice2)
        layers.append(dice3)
        layers.append(dice4)
        layers.append(dice5)
        layers.append(dice6)
    }
    
    func addDice() {
        let size: CGFloat = 150
        let viewFrame = UIScreen.main.bounds
        var diceTransform = CATransform3DIdentity
        diceView.frame = CGRect(x: 0, y: viewFrame.maxY / 2 - (size / 2), width: viewFrame.width, height: size)
        
        //1
        let dice1 = UIImageView.init(image: UIImage(named: "bc_0"))
        dice1.tag = 0
        dice1.contentMode = .scaleToFill
        dice1.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice1.layer.transform = diceTransform
        //2
        let dice2 = UIImageView.init(image: UIImage(named: "bc_1"))
        dice2.tag = 1
        dice2.contentMode = .scaleToFill
        dice2.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 90), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice2.layer.transform = diceTransform
        
        //3
        let dice3 = UIImageView.init(image: UIImage(named: "bc_2"))
        dice3.tag = 2
        dice3.contentMode = .scaleToFill
        dice3.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 180), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice3.layer.transform = diceTransform
        
//        //4
        let dice4 = UIImageView.init(image: UIImage(named: "bc_3"))
        dice4.tag = 3
        dice4.contentMode = .scaleToFill
        dice4.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 270), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice4.layer.transform = diceTransform
//
//        //5
        let dice5 = UIImageView.init(image: UIImage(named: "bc_4"))
        dice5.tag = 4
        dice5.contentMode = .scaleToFill
        dice5.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 90), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice5.layer.transform = diceTransform
//
//        //6
        let dice6 = UIImageView.init(image: UIImage(named: "bc_5"))
        dice6.tag = 5
        dice6.contentMode = .scaleToFill
        dice6.frame = CGRect(x: viewFrame.maxX / 2 - (size / 2), y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 270), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice6.layer.transform = diceTransform
        
        diceView.addSubview(dice1)
        diceView.addSubview(dice2)
        diceView.addSubview(dice3)
        diceView.addSubview(dice4)
        diceView.addSubview(dice5)
        diceView.addSubview(dice6)
//        dice1.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        view.addSubview(diceView)
//        let viewFrame = UIScreen.main.bounds
//
//        var diceTransform = CATransform3DIdentity
//
//        diceView.frame = CGRect(x: 0, y: viewFrame.maxY / 2 - 50, width: viewFrame.width, height: 100)
//
//        //1
//        let dice1 = UIImageView.init(image: UIImage(named: "dice1"))
//        dice1.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
//
//        //2
//        let dice2 = UIImageView.init(image: UIImage(named: "dice2"))
//        dice2.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
//        diceTransform = CATransform3DRotate(CATransform3DIdentity, (CGFloat.pi / 2), 0, 1, 0)
//        dice2.layer.transform = diceTransform
//
//        //3
//        let dice3 = UIImageView.init(image: UIImage(named: "dice3"))
//        dice3.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
//        diceTransform = CATransform3DRotate(CATransform3DIdentity, (-CGFloat.pi / 2), 1, 0, 0)
//        dice3.layer.transform = diceTransform
//
//        diceView.addSubview(dice1)
//        diceView.addSubview(dice2)
//        diceView.addSubview(dice3)
//
//        view.addSubview(diceView)
    }
}

extension DiceController {
    func setupGesture() {
        view .addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(_:))))
    }
    
    @objc func panGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        let point = recognizer.translation(in: diceView)
        let angleX = angle.x + (point.x/50)
        let angleY = angle.y - (point.y/50)
        
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        transform = CATransform3DRotate(transform, angleX, 0, 1, 0)
        transform = CATransform3DRotate(transform, angleY, 1, 0, 0)
//        diceView.subviews.first?.layer.transform = transform
        diceView.layer.sublayerTransform = transform
        
        if recognizer.state == .ended {
            angle.x = angleX
            angle.y = angleY
        }
    }
}
