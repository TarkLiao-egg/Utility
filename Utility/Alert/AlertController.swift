import UIKit

class AlertController: UIViewController {
    
    var backgroundView: UIView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    var confirmButton: UIButton!
    var cancelButton: UIButton!
    
    var confirmButtonAction: (() -> Void)?
    var cancelButtonAction: (() -> Void)?
    var closeAction: (() -> Void)?
    var windowCloseAction: (() -> Void)?
    
    init(action: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        windowCloseAction = action
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
    }
    
    func configure(_ model: AlertModel) {
        titleLabel.text = model.titleString
        descriptionLabel.text = model.descriptionString
        confirmButtonAction = model.confirmButtonAction
        cancelButtonAction = model.cancelButtonAction
    }
}

extension AlertController {
    func setupButton() {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterialDark)
        let effecview = UIVisualEffectView(effect: blur)
        effecview.alpha = 0.4
        backgroundView.addSubview(effecview)
        effecview.translatesAutoresizingMaskIntoConstraints = false
        effecview.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        effecview.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        effecview.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        effecview.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        effecview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonPressed)))
        
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    }
    
    @objc func closeButtonPressed() {
        closeAction?()
        windowCloseAction?()
    }
    
    @objc func confirmButtonPressed() {
        confirmButtonAction?()
        windowCloseAction?()
    }
    
    @objc func cancelButtonPressed() {
        cancelButtonAction?()
        windowCloseAction?()
    }
}

extension AlertController {
    func setupUI() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let shadowView = getShadowView()
        view.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shadowView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        shadowView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.856).isActive = true
    }
    
    func getShadowView() -> UIView {
        
        
        let shadowView = UIView()
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        shadowView.layer.cornerRadius = 16
        shadowView.layer.shadowRadius = 16
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        shadowView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(getPadding(height: 28))
        
        
        titleLabel = UILabel()
        titleLabel.text = "Wallpaper"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(red: 85 / 255, green: 85 / 255, blue: 85 / 255, alpha: 1)
        titleLabel.font = UIFont(name: "PingFangTC-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24)
        stackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(getPadding(height: 28))
        
        stackView.addArrangedSubview(getLineView())
        
        stackView.addArrangedSubview(getPadding(height: 30))
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Do you save wallpapers to your mobile phone photo album?"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(red: 85 / 255, green: 85 / 255, blue: 85 / 255, alpha: 1)
        descriptionLabel.font = UIFont(name: "PingFangTC-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)
        stackView.addArrangedSubview(descriptionLabel)
        
        stackView.addArrangedSubview(getPadding(height: 30))
        
        stackView.addArrangedSubview(getConfirmButtonView())
        
        stackView.addArrangedSubview(getPadding(height: 12))
        
        stackView.addArrangedSubview(getCancelButtonView())
        
        stackView.addArrangedSubview(getPadding(height: 30))
        return shadowView
    }
    
    func getConfirmButtonView() -> UIView {
        let confirmView = UIView()
        confirmView.backgroundColor = .white
        
        
        confirmButton = UIButton()
        confirmButton.setTitle("YES", for: .normal)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14)
        confirmView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirmButton.topAnchor.constraint(equalTo: confirmView.topAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: confirmView.bottomAnchor).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: confirmView.leadingAnchor, constant: 19).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: confirmView.trailingAnchor, constant: -19).isActive = true
        
        let shadowView = UIView()
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        shadowView.layer.cornerRadius = 7
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        confirmView.insertSubview(shadowView, at: 0)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.topAnchor.constraint(equalTo: confirmButton.topAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: confirmButton.bottomAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: 19).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: confirmButton.trailingAnchor, constant: -19).isActive = true
        return confirmView
    }
    
    func getCancelButtonView() -> UIView {
        let cancelView = UIView()
        cancelView.backgroundColor = .white
        
        cancelButton = UIButton()
        cancelButton.setTitle("NO", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14)
        cancelView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.topAnchor.constraint(equalTo: cancelView.topAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: cancelView.bottomAnchor).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: cancelView.leadingAnchor, constant: 19).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: cancelView.trailingAnchor, constant: -19).isActive = true
        
        let shadowView = UIView()
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        shadowView.layer.cornerRadius = 7
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cancelView.insertSubview(shadowView, at: 0)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.topAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: 19).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: -19).isActive = true
        return cancelView
    }
    
    func getLineView() -> UIView {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        let line = UIView()
        line.backgroundColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
        lineView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.topAnchor.constraint(equalTo: lineView.topAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: lineView.bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: lineView.leadingAnchor, constant: 19).isActive = true
        line.trailingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: -19).isActive = true
        return lineView
    }
    
    func getPadding(height: CGFloat) -> UIView {
        let paddingView = UIView()
        paddingView.backgroundColor = .clear
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return paddingView
    }
}
