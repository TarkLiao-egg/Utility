//
//  CollectionViewCell.swift
//  Utility
//
//  Created by 廖力頡 on 2022/4/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var initValue: Int = 0
    
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
        
    }
}

extension CollectionViewCell {
    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
    }
}
