import UIKit
@available(iOS 13.0.0, *)
class CircleDragController: UIViewController {
    let circleDragView = CircleDragView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleDragView.backgroundColor = .red
        view.addSubview(circleDragView)
        circleDragView.snp.makeConstraints { make in
            make.width.equalTo(circleDragView.snp.height)
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

}
