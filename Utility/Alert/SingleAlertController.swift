import UIKit

class SingleAlertController: AlertController {
    
    override func viewDidLoad() {
        setupUI()
        setupStackView()
        setupButton()
    }
    
    func setupStackView() {
        stackView.addArrangedSubview(getPadding(height: 43))
        stackView.addArrangedSubview(getTitleView())
        stackView.addArrangedSubview(getPadding(height: 10))
        stackView.addArrangedSubview(getDescriptionView())
        stackView.addArrangedSubview(getPadding(height: 36))
        stackView.addArrangedSubview(getConfirmButtonView())
        stackView.addArrangedSubview(getPadding(height: 24))
    }
}
