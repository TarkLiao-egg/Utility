import UIKit



class CustomTableView<T: UITableViewCell>: UITableView, UITableViewDataSource, UITableViewDelegate {
    private var datas = [Any]()
    
    init(type: T.Type) {
        super.init(frame: .zero, style: .plain)
        backgroundColor = .clear
        separatorStyle = .none
        delegate = self
        dataSource = self
        register(type, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? T else { return UITableViewCell() }
        cell.configure(datas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func setData(_ datas: [Any]) {
        self.datas = datas
        reloadData()
    }
    
}
