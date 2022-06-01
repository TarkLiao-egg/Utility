import UIKit

class MulitipleAlertController: AlertController {
    
    override func viewDidLoad() {
        setupUI()
        setupStackView()
        setupButton()
    }
    
    func setupStackView() {
        stackView.addArrangedSubview(getPadding(height: 56))
        stackView.addArrangedSubview(getTitleView())
        stackView.addArrangedSubview(getPadding(height: 40))
        stackView.addArrangedSubview(getConfirmButtonView())
        stackView.addArrangedSubview(getPadding(height: 12))
        stackView.addArrangedSubview(getCancelButtonView())
        stackView.addArrangedSubview(getPadding(height: 24))
    }
}
