import UIKit

class CustomCollectionView: UICollectionView {
    let layout = UICollectionViewFlowLayout()
    var datas = [Int]()
    var isSelect: Int = -1
    
    init() {
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        backgroundColor = .clear
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCollectionView {
    func setData(_ items: [Int]) {
        datas = items
        reloadData()
    }
    
}

extension CustomCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
