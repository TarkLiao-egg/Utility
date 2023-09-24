import UIKit

class DiceView: UIView {
    var layers = [CALayer]()
    init(size: CGFloat) {
        super.init(frame: .zero)
        addDiceLayer(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDiceLayer(size: CGFloat) {
//        let size: CGFloat = 150
//        let viewFrame = UIScreen.main.bounds
        var diceTransform = CATransform3DIdentity
//        frame = CGRect(x: 0, y: viewFrame.maxY / 2 - (size / 2), width: viewFrame.width, height: size)
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        let diceX: CGFloat = 0 //viewFrame.maxX / 2 - (size / 2)
        //1
        let dice1 = CALayer()
        dice1.name = "0"
        dice1.contents = UIImage(named: "bc_0")?.cgImage
        dice1.contentsGravity = .resizeAspectFill
        dice1.frame = CGRect(x: diceX, y: 0, width: size, height: size)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice1.transform = diceTransform
        
        //2
        let dice2 = CALayer()
        dice2.contents = UIImage(named: "bc_1")?.cgImage
        dice2.contentsGravity = .resizeAspectFill
        dice2.frame = CGRect(x: diceX, y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 90), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice2.transform = diceTransform
        
        //3
        let dice3 = CALayer()
        dice3.contents = UIImage(named: "bc_2")?.cgImage
        dice3.contentsGravity = .resizeAspectFill
        dice3.frame = CGRect(x: diceX, y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 180), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice3.transform = diceTransform
        
//        //4
        let dice4 = CALayer()
        dice4.contents = UIImage(named: "bc_3")?.cgImage
        dice4.contentsGravity = .resizeAspectFill
        dice4.frame = CGRect(x: diceX, y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 270), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice4.transform = diceTransform
//
//        //5
        let dice5 = CALayer()
        dice5.contents = UIImage(named: "bc_4")?.cgImage
        dice5.contentsGravity = .resizeAspectFill
        dice5.frame = CGRect(x: diceX, y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 90), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice5.transform = diceTransform
//
//        //6
        let dice6 = CALayer()
        dice6.contents = UIImage(named: "bc_5")?.cgImage
        dice6.contentsGravity = .resizeAspectFill
        dice6.frame = CGRect(x: diceX, y: 0, width: size, height: size)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, degreeToRadians(deg: 270), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, size / 2)
        dice6.transform = diceTransform
        layer.addSublayer(dice1)
        layer.addSublayer(dice2)
        layer.addSublayer(dice3)
        layer.addSublayer(dice4)
        layer.addSublayer(dice5)
        layer.addSublayer(dice6)
//        dice1.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        view.addSubview(diceView)
        
        layers.append(dice1)
        layers.append(dice2)
        layers.append(dice3)
        layers.append(dice4)
        layers.append(dice5)
        layers.append(dice6)
    }
    
    func degreeToRadians(deg: CGFloat) -> CGFloat {
        return (deg * CGFloat.pi) / 180
    }
}
