//
//  InsideShadowController.swift
//  Utility
//
//  Created by 廖力頡 on 2022/4/17.
//

import UIKit

class InsideShadowController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .white
        let functionView = FunctionCodeView()
        functionView.forSelf {
            $0.setBackground(.white)
            $0.setCornerRadius(10)
            $0.setBorder(40, borderColors: .white, .red, borderWidth: 2)
            $0.setGradient(.red, .yellow, axis: .vertical)
//            $0.setShadow()
            $0.setShadow(shadowOpacity: 1, shadowColor: .blue, shadowOffset: CGSize(width: 10, height: 10), shadowWidth: 15)
            $0.setInnerShadow()
        }
        view.addSubview(functionView)
        functionView.translatesAutoresizingMaskIntoConstraints = false
        functionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        functionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        functionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        functionView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
