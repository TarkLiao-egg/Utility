import UIKit
import Combine

class TestController: UIViewController {
    let customView = CustomTableView(type: TableViewCell.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        customView.setData([1,2,34,5,6,7,8,89])
    }
}
