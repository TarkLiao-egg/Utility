import UIKit
import SnapKit

class ScrollEditController: UIViewController {
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboard()
    }
    
}

// MARK: Keyboard
extension ScrollEditController {
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let keyboardHeight: CGFloat = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().offset(-(keyboardHeight))
            make.leading.trailing.equalToSuperview()
        }
        view.layoutIfNeeded()
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.snp.remakeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        view.layoutIfNeeded()
    }
}

extension ScrollEditController {
    func setupUI() {
        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        let stackView = UIStackView()
        stackView.forSelf {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fill
            $0.alignment = .fill
        }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }
}

