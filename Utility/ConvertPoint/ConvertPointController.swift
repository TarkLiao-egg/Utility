import UIKit

class ConvertPointController: UIViewController {
    var gray1: UIView!
    var blue2: UIView!
    var rred3: UIView!
    var gren4: UIView!
    
    var gray5: UIView!
    var blue6: UIView!
    var rred7: UIView!
    var gren8: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UI()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(testAction)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //A.convert(B.frame, to: C) = (x: A.x + B.x - C.x, y: A.y + B.y - C.y, width: B.width, height: B.height)
        //被轉換的父物件.convert(被轉換物件.frame, to: 轉換至哪個物件) = 被轉換物件的frame在 to物件的frame
        
        //A.convert(B.frame, to: C) = (x: B.x + C.x - A.x, y: B.y + C.y - A.y, width: B.width, height: B.height)
        //轉換至哪個物件.convert(被轉換物件.frame, from: 被轉換的父物件) = 被轉換物件的frame在 to物件的frame
        
        
        //A.convert(B.point, to: C) = (x: A.x + B.x - C.x, y: A.y + B.y - C.y)
        //被轉換的物件.convert(CGPoint(x: 被轉換物件的x座標, y:被轉換物件的y座標, to: 轉換至哪個物件) = 被轉換物件的座標 在to物件的座標
        
        //A.convert(B.point, from: C) = (x: B.x + C.x - A.x, y: B.y + C.y - A.y)
        //轉換至哪個物件.convert(CGPoint(x: 被轉換物件的x座標, y:被轉換物件的y座標, from: 被轉換的物件) = 被轉換物件的座標 在to物件的座標
        
        //MARK: 轉換至哪個物件具局限性，只能是被轉
//        gray1 = (  0,   0, 320, 320)
//        blue2 = ( 40,  40, 240, 240)
//        rred3 = ( 80,  80, 160, 160)
//        gren4 = (120, 120,  80,  80)
        
        rred3.convert(gren4.frame, to: blue2) == blue2.convert(gren4.frame, from: rred3)
        
        gray1.convert(CGPoint(x:0, y:0), to: rred3) == rred3.convert(CGPoint(x:0, y:0), from: gray1)
    }

    @objc func testAction() {
        print("tark")
    }
}

extension ConvertPointController {
    func UI() {
        gray1 = UIView()
        gray1.backgroundColor = .gray
        view.addSubview(gray1)
        gray1.snp.makeConstraints { make in
            make.size.equalTo(320)
            make.top.leading.equalToSuperview()
        }
        
        blue2 = UIView()
        blue2.backgroundColor = .blue
        gray1.addSubview(blue2)
        blue2.snp.makeConstraints { make in
            make.size.equalTo(240)
            make.center.equalToSuperview()
        }
        
        rred3 = UIView()
        rred3.backgroundColor = .red
        blue2.addSubview(rred3)
        rred3.snp.makeConstraints { make in
            make.size.equalTo(160)
            make.center.equalToSuperview()
        }
        
        gren4 = UIView()
        gren4.backgroundColor = .green
        rred3.addSubview(gren4)
        gren4.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.center.equalToSuperview()
        }
        
        
        gray5 = UIView()
        gray5.backgroundColor = .gray
        view.addSubview(gray5)
        gray5.snp.makeConstraints { make in
            make.size.equalTo(320)
            make.bottom.leading.equalToSuperview()
        }
        
        blue6 = UIView()
        blue6.backgroundColor = .blue
        gray5.addSubview(blue6)
        blue6.snp.makeConstraints { make in
            make.size.equalTo(240)
            make.center.equalToSuperview()
        }
        
        rred7 = UIView()
        rred7.backgroundColor = .red
        blue6.addSubview(rred7)
        rred7.snp.makeConstraints { make in
            make.size.equalTo(160)
            make.center.equalToSuperview()
        }
        
        gren8 = UIView()
        gren8.backgroundColor = .green
        rred7.addSubview(gren8)
        gren8.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.center.equalToSuperview()
        }
    }
}
