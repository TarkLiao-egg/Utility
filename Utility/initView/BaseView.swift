import UIKit

protocol View {
    func setupView()
}

class BaseView: UIView, View {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {}
}
