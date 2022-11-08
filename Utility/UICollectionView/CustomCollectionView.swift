import UIKit

class CustomCollectionView<T: UICollectionViewCell>: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let layout = UICollectionViewFlowLayout()
    var datas = [Any]()
    var isSelect: Int = -1
    
    init(type: T.Type) {
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(type, forCellWithReuseIdentifier: "cell")
        backgroundColor = .clear
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.configure(datas[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickCell(datas[indexPath.row])
        isSelect = indexPath.row
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - 32 - 29 - 20) / 3
        let newWidth = CGFloat(Int(width))
        return CGSize(width: newWidth, height: newWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CustomCollectionView {
    func setData(_ items: [Any]) {
        datas = items
        reloadData()
    }
    
}

extension UICollectionViewCell {
    @objc func configure(_ model: Any) {
        
    }
}

extension UIResponder {
    @objc func clickCell(_ model: Any?) {
        next?.clickCell(model)
    }
    
    @objc func shareImage(_ model: Any?) {
        next?.shareImage(model)
    }
    
    @objc func changeTheme(_ model: Any?) {
        next?.changeTheme(model)
    }
}
