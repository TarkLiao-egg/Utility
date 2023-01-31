import UIKit

enum Section: CaseIterable {
    case one
}

@available(iOS 13.0, *)
class CustomDiffCollectionView<T: UICollectionViewCell, D: Hashable>: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    lazy var datasource = makeDatasource()
    let layout = UICollectionViewFlowLayout()
    var datas = [D]()
    var isSelect: Int = -1
    
    init(isAuto: Bool = false) {
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        register(T.self, forCellWithReuseIdentifier: "cell")
        backgroundColor = .clear
        delegate = self
        dataSource = datasource
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        if isAuto {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeDatasource() -> UICollectionViewDiffableDataSource<Section, D> {
        return UICollectionViewDiffableDataSource<Section, D>(collectionView: self, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? T
            cell?.configure(self.datas[indexPath.row])
            return cell ?? UICollectionViewCell()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = datasource.itemIdentifier(for: indexPath) {
            clickCell(data)
        }
        isSelect = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height * 3 / 4, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

@available(iOS 13.0, *)
extension CustomDiffCollectionView {
    func setData(_ items: [Any]) {
        guard let items = items as? [D] else { return }
        datas = items
        var snapshot = NSDiffableDataSourceSnapshot<Section, D>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items, toSection: .one)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
}
