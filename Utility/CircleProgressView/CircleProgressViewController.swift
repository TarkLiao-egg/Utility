import UIKit
import SnapKit
import Combine
import SwiftUI

@available(iOS 13.0, *)
class CircleProgressViewController: UIViewController {
    let circleView = CircleProgressView(lineWidth: 10)
    var cancelC = [AnyCancellable]()
    var time: Double = 10
    var current: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        circleView.backgroundColor = .yellow
        circleView.setShadow()
        view.addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }
        Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [unowned self] _ in
            if current > 9 {
                current = 0
                circleView.setPercent(0)
                return
            }
            current += 1
            circleView.setPercent(current / time)
        }.store(in: &cancelC)
    }
}
