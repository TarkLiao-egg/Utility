//
//  ResponderChainController.swift
//  Utility
//
//  Created by 廖力頡 on 2022/9/1.
//

import UIKit


extension UINavigationController: TestPro {
    func testResponse() {
        print("UINavigationController")
    }
    
    override func doAnything() {
        testResponse()
//        next?.doAnything()
    }
    
    func navgationAction() {
        print("navgationAction")
    }
}

class ResponderChainController: UIViewController, TestPro {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIButton().VS({ [unowned self] in
            $0.setTitle("Random", for: .normal)
            $0.addTarget(nil, action: #selector(testAction), for: .touchUpInside)
        }, view, { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        })
    }
        
    @objc func testAction() {
        testResonder()
        testResponse()
    }
    override func doAnything() {
        print("ResponderChainController")
//        next?.doAnything()
    }
    
    static func start() -> UINavigationController {
        return UINavigationController(rootViewController: ResponderChainController())
    }
}

extension ResponderChainController {
    func testResonder() {
        (next?.next?.next?.next as? UINavigationController)?.navgationAction()
    }
}
protocol TestPro {}
extension UIResponder {
    @objc func doAnything() {
        next?.doAnything()
    }
}

extension TestPro where Self: UIResponder {
    func testResponse() {
        doAnything()
        next?.doAnything()
    }
}
