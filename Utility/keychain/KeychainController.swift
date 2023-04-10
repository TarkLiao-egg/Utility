import UIKit

class KeyChainController: UIViewController, UITextFieldDelegate {
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    private lazy var keyTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return textField
    }()
    let identify: String = "test"
    var currentTextField: UITextField?
    private lazy var readButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return button
    }()
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return button
    }()
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return button
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        
        view.addSubview(keyTextField)
        keyTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(statusLabel.snp.top).offset(-20)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        if currentTextField != textField {
            return true
        }
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        self.view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("BeginEditing")
        currentTextField = textField
    }
    @objc func saveButtonAction() {
        statusLabel.text = ""
        let text = keyTextField.text
        if text != "" {
            keyTextField.resignFirstResponder()
            let saveBool = KeychainManager.keyChainSaveData(data: text as Any, withIdentifier: identify)
            if saveBool {
                statusLabel.text = "Status: keychain save success"
            } else {
                statusLabel.text = "Status: keychain save fail"
            }
        } else {
            statusLabel.text = "Status: content empty"
        }
        
    }
    @objc func readButtonAction() {
        statusLabel.text = ""
        if let getString = KeychainManager.keyChainReadData(identifier: identify) {
            statusLabel.text = getString as? String
        } else {
            statusLabel.text = "nil"
        }
    }
    @objc func updateButtonAction() {
        statusLabel.text = ""
        let text = keyTextField.text
        if text != "" {
            let updataBool = KeychainManager.keyChainUpdata(data: text, withIdentifier: identify)
            if updataBool {
                statusLabel.text = "Status: keychain update success"
            } else {
                statusLabel.text = "Status: keychain update fail"
            }
        } else {
            statusLabel.text = "Status: content empty"
        }
    }
    @objc func deleteButtonAction() {
        KeychainManager.keyChianDelete(identifier: identify)

        if let getString = KeychainManager.keyChainReadData(identifier: identify) {
            statusLabel.text = getString as? String
        } else {
            statusLabel.text = "Status: keychain delete success"
        }
    }
}
