import UIKit
import SnapKit

struct ScrollKeyboardObject {
    var parent: UIView?
    let scrollLine = UIView()
    var scrollShowConstraints: ((CGFloat) -> (ConstraintMaker) -> Void)?
    var scrollHideConstraints: ((ConstraintMaker) -> Void)?
}

class ScrollEditController: UIViewController {
    var scrollView: UIScrollView!
    var scrollKeyboardObj = ScrollKeyboardObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboard()
        
        setupScrollLine()
    }
    
    func setupScrollLine() {
        scrollKeyboardObj.scrollHideConstraints = {make in
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(2)
        }
        
        scrollKeyboardObj.scrollShowConstraints = { keyboardHeight in
            return { make in
                make.top.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-(keyboardHeight))
            }
        }
        scrollKeyboardObj.parent = view
    }
}

// MARK: Keyboard
extension ScrollEditController {
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardHeight: CGFloat = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        // ScrollView
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().offset(-(keyboardHeight))
            make.leading.trailing.equalToSuperview()
        }
        
        // ScrollKeyboardObject
        guard let scrollShowConstraints = scrollKeyboardObj.scrollShowConstraints else { return }
        scrollKeyboardObj.scrollLine.snp.remakeConstraints(scrollShowConstraints(keyboardHeight))
        
        view.layoutIfNeeded()
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        // ScrollView
        scrollView.snp.remakeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        // ScrollKeyboardObject
        guard let scrollHideConstraints = scrollKeyboardObj.scrollHideConstraints else { return }
        scrollKeyboardObj.scrollLine.snp.remakeConstraints(scrollHideConstraints)
        view.layoutIfNeeded()
    }
}

extension ScrollEditController {
    func setupUI() {
        view.backgroundColor = .white
        
        scrollView = UIScrollView().VS(nil, view) { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        let stackView = UIStackView().VS({
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fill
            $0.alignment = .fill
        }, scrollView) { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }
}

