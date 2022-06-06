//
//  CollectionViewCell.swift
//  Utility
//
//  Created by 廖力頡 on 2022/4/23.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    var initValue: Int = 0
    var view: UIView!
    init(initValue: Int) {
        self.initValue = initValue
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.clipsToBounds = false
        contentView.clipsToBounds = false
        view.backgroundColor = UIColor(red: CGFloat.random(in: 0...255) / 255, green: CGFloat.random(in: 0...255) / 255, blue: CGFloat.random(in: 0...255) / 255, alpha: 1)
    }
}

extension CollectionViewCell {
    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        view = getView()
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1)
            make.height.equalToSuperview()
        }
    }
    
    func getView() -> UIView {
        let view = UIView()
        
        return view
    }
}
