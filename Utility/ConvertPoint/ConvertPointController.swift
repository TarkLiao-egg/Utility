import UIKit

class ConvertPointController: UIViewController {
    var gray1: UIView!
    var blue2: UIView!
    var rred3: UIView!
    var gren4: UIView!
    var yelo5: UIView!
    
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
        
        //A.convert(B.frame, to: C)
        //被轉換的父物件.convert(被轉換物件.frame, to: 轉換至哪個物件) = 被轉換物件的frame在 to物件的frame
        
        //A.convert(B.frame, from: C)
        //轉換至哪個物件.convert(被轉換物件.frame, from: 被轉換的父物件) = 被轉換物件的frame在 to物件的frame
        
        
        //A.convert(B.point, to: C)
        //被轉換的物件.convert(CGPoint(x: 被轉換物件的x座標, y:被轉換物件的y座標, to: 轉換至哪個物件) = 被轉換物件的座標 在to物件的座標
        
        //A.convert(B.point, from: C)
        //轉換至哪個物件.convert(CGPoint(x: 被轉換物件的x座標, y:被轉換物件的y座標, from: 被轉換的物件) = 被轉換物件的座標 在to物件的座標
        
        
//        gray1 = (  0,   0, 320, 320)
//        blue2 = ( 30,  30, 260, 260)
//        rred3 = ( 70,  70, 180, 180)
//        gren4 = (130, 130,  60,  60)
//        yelo5 = (140, 140,  40,  40)
        
//        (0.0, 0.0, 320.0, 320.0)
//        (30.0, 30.0, 260.0, 260.0)
//        (40.0, 40.0, 180.0, 180.0)
//        (60.0, 60.0, 60.0, 60.0)
//        (10.0, 10.0, 40.0, 40.0)
        let y5 = gren4.convert(yelo5.frame.origin, to: view).x
        let g4 = rred3.convert(gren4.frame.origin, to: view).x
        let r3 = blue2.convert(rred3.frame.origin, to: view).x
        let b2 = gray1.convert(blue2.frame.origin, to: view).x
        let gr1 = gray1.convert(gray1.frame.origin, to: view).x
        print(y5 - g4 - (g4 - g4))
        print(y5 - g4 - (g4 - r3))
        print(y5 - g4 - (g4 - gr1))
        print(r3 - y5 - (b2 - gr1))
        print(gren4.convert(yelo5.frame.origin, to: gren4))// (10.0, 10.0)
        print(rred3.convert(yelo5.frame.origin, to: gren4))// (-50.0, -50.0)
        print(gray1.convert(yelo5.frame.origin, to: gren4))// (-120.0, -120.0)
        print(gray1.convert(rred3.frame.origin, to: yelo5))// (-100.0, -100.0)
//        print(gray1.convert(gray1.frame.origin, to: view))
//        print(gray1.convert(blue2.frame.origin, to: view))
//        print(blue2.convert(rred3.frame.origin, to: view))
//        print(rred3.convert(gren4.frame.origin, to: view))
//        print(gren4.convert(yelo5.frame.origin, to: view))
    }

    @objc func testAction(tap: UITapGestureRecognizer) {
        print(tap.location(in: view))
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
            make.size.equalTo(260)
            make.center.equalToSuperview()
        }
        
        rred3 = UIView()
        rred3.backgroundColor = .red
        blue2.addSubview(rred3)
        rred3.snp.makeConstraints { make in
            make.size.equalTo(180)
            make.center.equalToSuperview()
        }
        
        gren4 = UIView()
        gren4.backgroundColor = .green
        rred3.addSubview(gren4)
        gren4.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.center.equalToSuperview()
        }
        
        yelo5 = UIView()
        yelo5.backgroundColor = .yellow
        gren4.addSubview(yelo5)
        yelo5.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
        view.layoutIfNeeded()
        
//        print(gray1.frame)
//        print(blue2.frame)
//        print(rred3.frame)
//        print(gren4.frame)
//        print(yelo5.frame)
        
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
