import UIKit

class SingleAlertController: AlertController {
    
    override func viewDidLoad() {
        setupUI()
        setupStackView()
        setupButton()
    }
    
    func setupStackView() {
        stackView.addArrangedSubview(getPadding(height: 54))
        stackView.addArrangedSubview(getTitleView())
        stackView.addArrangedSubview(getPadding(height: 40))
        stackView.addArrangedSubview(getConfirmButtonView())
        stackView.addArrangedSubview(getPadding(height: 24))
    }
}
