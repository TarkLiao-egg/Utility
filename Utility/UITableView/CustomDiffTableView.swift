import UIKit


@available(iOS 13.0, *)
class CustomDiffTableView<T: UITableViewCell, D: Hashable>: UITableView, UITableViewDelegate {
    private var datas = [D]()
    lazy var datasource = makeDatasource()
    
    init(type: T.Type) {
        super.init(frame: .zero, style: .plain)
        backgroundColor = .clear
        separatorStyle = .none
        delegate = self
        dataSource = datasource
        register(type, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeDatasource() -> UITableViewDiffableDataSource<Section, D> {
        return UITableViewDiffableDataSource<Section, D>(tableView: self, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let self = self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? T
            cell?.configure(self.datas[indexPath.row])
            return cell ?? UITableViewCell()
        })
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = datasource.itemIdentifier(for: indexPath) {
            clickCell(data)
        }
    }
}

@available(iOS 13.0, *)
extension CustomDiffTableView {
    func setData(_ items: [Any]) {
        guard let items = items as? [D] else { return }
        datas = items
        var snapshot = NSDiffableDataSourceSnapshot<Section, D>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items, toSection: .one)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension UITableViewCell {
    @objc func configure(_ model: Any) {
        
    }
}
