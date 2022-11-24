//
//  CardCollectionView.swift
//  Utility
//
//  Created by 廖力頡 on 2022/11/24.
//

import UIKit

class CardCollectionView: UICollectionView {
    let layout = CardViewLayout()
    var datas = [Any]()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        register(CardCollectCell.self, forCellWithReuseIdentifier: "cell")
        backgroundColor = .black
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CardCollectionView {
    func setData(_ datas: [Any]) {
        self.datas = datas
        reloadData()
    }
}

extension CardCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardCollectCell else { return UICollectionViewCell() }
        cell.configure(datas[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickCell(datas[indexPath.row])
        print("select: " + String(indexPath.row))
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        print("minimumLineSpacingForSectionAt")
//        return 14
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}
