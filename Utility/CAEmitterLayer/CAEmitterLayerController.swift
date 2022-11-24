//
//  CAEmitterLayerController.swift
//  Utility
//
//  Created by 廖力頡 on 2022/11/24.
//

import UIKit

class CAEmitterLayerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = UIView()
        rootView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        view.addSubview(rootView)
        rootView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        view.layoutIfNeeded()
        
        let snowEmitterCell = CAEmitterCell()
        snowEmitterCell.contents = UIImage(named: "default")?.cgImage
        snowEmitterCell.birthRate = 6
        snowEmitterCell.lifetime = 20
        snowEmitterCell.velocity = 100
        snowEmitterCell.scale = 0.3
        snowEmitterCell.scaleRange = 0.3
        snowEmitterCell.yAcceleration = 30
        snowEmitterCell.scaleSpeed = -0.02
        snowEmitterCell.spin = 0.5
        snowEmitterCell.spinRange = 1
//        snowEmitterCell.emissionLatitude = CGFloat.pi
//        snowEmitterCell.emissionLongitude = CGFloat.pi
//        snowEmitterCell.emissionRange = CGFloat.pi
        
        let snowEmitterLayer = CAEmitterLayer()
        snowEmitterLayer.emitterCells = [snowEmitterCell]
        snowEmitterLayer.emitterPosition = CGPoint(x: rootView.bounds.width / 2, y: rootView.bounds.height / 2)
        snowEmitterLayer.emitterSize = CGSize(width: rootView.bounds.width, height: 0)
        snowEmitterLayer.emitterShape = .line
//        snowEmitterLayer.scale = 2
//        snowEmitterLayer.birthRate = 2
        rootView.layer.addSublayer(snowEmitterLayer)
    }
}
