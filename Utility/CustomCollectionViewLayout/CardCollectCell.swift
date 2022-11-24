//
//  CollectionViewCell.swift
//  Utility
//
//  Created by 廖力頡 on 2022/4/23.
//

import UIKit
import SnapKit

class CardCollectCell: UICollectionViewCell {
    var data: Any?
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(_ data: Any) {
        self.data = data
        view.backgroundColor = UIColor(red: CGFloat.random(in: 0...255) / 255, green: CGFloat.random(in: 0...255) / 255, blue: CGFloat.random(in: 0...255) / 255, alpha: 1)
    }
}

extension CardCollectCell {
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
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }
}
