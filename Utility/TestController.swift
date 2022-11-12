import UIKit
import SnapKit
import Combine
import SwiftUI

@available(iOS 13.0, *)
class TestController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}

@available(iOS 13.0, *)
extension TestController {
    func setupButton() {
        UIButton().VS({
            $0.setTitle("Test", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.addTarget(self, action: #selector(self.testAction), for: .touchUpInside)
        }, view) { make in
            make.size.equalTo(60)
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    @objc func testAction() {
        
    }
}
