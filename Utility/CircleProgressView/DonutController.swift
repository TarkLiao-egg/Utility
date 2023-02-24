import UIKit
import Combine
@available(iOS 13.0, *)
class DonutController: UIViewController {
    let donutView = DonutView(lineWidth: 30)
    var cancelC = [AnyCancellable]()
    var time: Double = 10
    var current: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        donutView.backgroundColor = .white
        donutView.clipsToBounds = false
        view.addSubview(donutView)
        donutView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(300)
        }
    }
}
