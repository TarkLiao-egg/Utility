//
//  CardCollectionViewController.swift
//  Utility
//
//  Created by 廖力頡 on 2022/11/24.
//

import UIKit

class CardCollectionViewController: UIViewController {
    let collectionView = CardCollectionView()
    let datas = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.setData(datas)
    }
    
}
