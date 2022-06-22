import UIKit

class AlertController: UIViewController {
    let backgroundColor: UIColor = .white
    var isLock: Bool = false
    
    var stackView: UIStackView!
    var backgroundView: UIView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    var confirmButton: UIButton?
    var cancelButton: UIButton?
    
    var confirmButtonAction: (() -> Void)?
    var cancelButtonAction: (() -> Void)?
    var closeAction: (() -> Void)?
    var windowCloseAction: (() -> Void)?
    var anyAction: [((Any?) -> Void)] = []
    var any: Any?
    
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
        isLock = model.isLock
        titleLabel.text = model.titleString
        titleLabel.textColor = model.titleColor
        descriptionLabel.text = model.descriptionString
        descriptionLabel.textColor = model.descriptionColor
        confirmButton?.setTitle(model.confirmButtonString, for: .normal)
        confirmButton?.setTitleColor(model.confirmButtonTextColor, for: .normal)
        confirmButtonAction = model.confirmButtonAction
        cancelButtonAction = model.cancelButtonAction
        cancelButton?.setTitle(model.cancelButtonString, for: .normal)
        cancelButton?.setTitleColor(model.cancelButtonTextColor, for: .normal)
        closeAction = model.closeAction
        anyAction = model.anyAction
        any = model.any
    }
    
    func setupButton() {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let effecview = UIVisualEffectView(effect: blur)
        effecview.alpha = 0.4
        backgroundView.addSubview(effecview)
        effecview.translatesAutoresizingMaskIntoConstraints = false
        effecview.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        effecview.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        effecview.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        effecview.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        effecview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonPressed)))
        
        confirmButton?.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        cancelButton?.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    }
    
    @objc func closeButtonPressed() {
        if !isLock {
            closeAction?()
            windowCloseAction?()
        }
    }
    
    @objc func confirmButtonPressed() {
        confirmButtonAction?()
        closeAction?()
        windowCloseAction?()
    }
    
    @objc func cancelButtonPressed() {
        cancelButtonAction?()
        closeAction?()
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
        shadowView.backgroundColor = backgroundColor
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        shadowView.layer.cornerRadius = 16
        shadowView.layer.shadowRadius = 16
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        
        stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        shadowView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor).isActive = true
        
        titleLabel = UILabel()
        titleLabel.text = "Wallpaper"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "PingFangTC-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Do you save wallpapers to your mobile phone photo album?"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont(name: "PingFangTC-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)
        return shadowView
    }
    
    func getConfirmButtonView() -> UIView {
        let confirmView = UIView()
        confirmView.backgroundColor = .clear
        
        
        confirmButton = UIButton()
        confirmButton?.setTitle("OK", for: .normal)
        confirmButton?.setTitleColor(.white, for: .normal)
        confirmButton?.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14)
        confirmView.addSubview(confirmButton!)
        confirmButton?.translatesAutoresizingMaskIntoConstraints = false
        confirmButton?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirmButton?.topAnchor.constraint(equalTo: confirmView.topAnchor).isActive = true
        confirmButton?.bottomAnchor.constraint(equalTo: confirmView.bottomAnchor).isActive = true
        confirmButton?.leadingAnchor.constraint(equalTo: confirmView.leadingAnchor, constant: 19).isActive = true
        confirmButton?.trailingAnchor.constraint(equalTo: confirmView.trailingAnchor, constant: -19).isActive = true
        
        let shadowView = UIView()
        shadowView.backgroundColor = backgroundColor
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        shadowView.layer.cornerRadius = 7
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        confirmView.insertSubview(shadowView, at: 0)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.topAnchor.constraint(equalTo: confirmButton!.topAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: confirmButton!.bottomAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: confirmButton!.leadingAnchor, constant: 19).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: confirmButton!.trailingAnchor, constant: -19).isActive = true
        return confirmView
    }
    
    func getCancelButtonView() -> UIView {
        let cancelView = UIView()
        cancelView.backgroundColor = backgroundColor
        
        cancelButton = UIButton()
        cancelButton?.setTitle("NO", for: .normal)
        cancelButton?.setTitleColor(.white, for: .normal)
        cancelButton?.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14)
        cancelView.addSubview(cancelButton!)
        cancelButton?.translatesAutoresizingMaskIntoConstraints = false
        cancelButton?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton?.topAnchor.constraint(equalTo: cancelView.topAnchor).isActive = true
        cancelButton?.bottomAnchor.constraint(equalTo: cancelView.bottomAnchor).isActive = true
        cancelButton?.leadingAnchor.constraint(equalTo: cancelView.leadingAnchor, constant: 19).isActive = true
        cancelButton?.trailingAnchor.constraint(equalTo: cancelView.trailingAnchor, constant: -19).isActive = true
        
        let shadowView = UIView()
        shadowView.backgroundColor = backgroundColor
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        shadowView.layer.cornerRadius = 7
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cancelView.insertSubview(shadowView, at: 0)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.topAnchor.constraint(equalTo: cancelButton!.topAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: cancelButton!.bottomAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: cancelButton!.leadingAnchor, constant: 19).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: cancelButton!.trailingAnchor, constant: -19).isActive = true
        return cancelView
    }
    
    func getTitleView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }
    
    func getDescriptionView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }
    
    func getLineView(color: UIColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)) -> UIView {
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
        paddingView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return paddingView
    }
}
