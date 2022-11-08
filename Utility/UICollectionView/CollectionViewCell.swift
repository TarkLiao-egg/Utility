//
//  CollectionViewCell.swift
//  Utility
//
//  Created by 廖力頡 on 2022/4/23.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    var data: Int = 0
    var initValue: Int = 0
    let label = UILabel()
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
    
    func configure(_ data: Int) {
        self.clipsToBounds = false
        contentView.clipsToBounds = false
        view.backgroundColor = UIColor(red: CGFloat.random(in: 0...255) / 255, green: CGFloat.random(in: 0...255) / 255, blue: CGFloat.random(in: 0...255) / 255, alpha: 1)
    }
    
    //forces the system to do one layout pass
    var isHeightCalculated: Bool = false

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        //Exhibit A - We need to cache our calculation to prevent a crash.
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
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
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }
}
