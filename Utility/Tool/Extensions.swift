import Foundation
import UIKit
import RxSwift

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

protocol OP_Declarative {}

extension OP_Declarative {
    func forSelf(_ closure: (Self) -> Void) {
        closure(self)
    }
}

extension NSObject: OP_Declarative {}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIColor {
    static func hex(_ hex: Int, opacity: Double = 1.0) -> UIColor {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: opacity)
    }
}

extension String {
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func getTimeStamp() -> Int {
        return Int(self.timeIntervalSince1970)
    }
    
    func getDateInfo(option: Calendar.Component) -> Int {
        switch option {
        case .year:
            return Calendar.current.dateComponents([option], from: self).year ?? -1
        case .month:
            return Calendar.current.dateComponents([option], from: self).month ?? -1
        case .day:
            return Calendar.current.dateComponents([option], from: self).day ?? -1
        case .hour:
            return Calendar.current.dateComponents([option], from: self).hour ?? -1
        case .minute:
            return Calendar.current.dateComponents([option], from: self).minute ?? -1
        default:
            return -1
        }
    }
}

extension CAGradientLayer {
    static func getGradientLayer(bounds: CGRect, axis: NSLayoutConstraint.Axis, colors: UIColor...) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.compactMap({$0.cgColor})
        if axis == .vertical {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }
        gradientLayer.locations = [0, 1]
        return gradientLayer
    }
}

extension UIScreen {
    static func SafeHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top ?? 0
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            return (window?.rootViewController?.view.frame.height ?? 0) - topPadding - bottomPadding
        } else {
            let window = UIApplication.shared.windows.first
            return window?.rootViewController?.view.frame.height ?? 0
        }
    }
}

extension UITextField {
    
    var isBlank: Bool {
        guard let text = self.text else { return true }
        return text.replacingOccurrences(of: " ", with: "") == ""
    }
    
    func addDoneButtonOnKeyboard(disposeBag: DisposeBag? = nil, doneAction: (() -> Void)? = nil, clearAction: (() -> Void)? = nil) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
        if let disposeBag = disposeBag, let doneAction = doneAction {
            done.rx.tap.subscribe(onNext: {
                doneAction()
                self.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        } else {
            done.action = #selector(doneButtonAction)
        }
        
        done.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.underlineColor: UIColor.clear], for: .normal)
        done.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.underlineColor: UIColor.clear], for: .selected)
        var items = [flexSpace, done]
        if let disposeBag = disposeBag {
            let del: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
            del.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.underlineColor: UIColor.clear], for: .normal)
            del.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.underlineColor: UIColor.clear], for: .selected)
            del.rx.tap.subscribe(onNext: {
                clearAction?()
                self.text = nil
                self.resignFirstResponder()
            })
            .disposed(by: disposeBag)
            items.insert(del, at: 0)
        }
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }

    @objc
    func doneButtonAction() {
        self.resignFirstResponder()
    }
}

extension UIFont {
    enum FontStyle {
        case regular
        case medium
        case bold
    }
    static func getDefaultFont(_ style: FontStyle, size: CGFloat) -> UIFont {
        switch style {
        case .regular:
            return UIFont(name: "PingFangTC-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        case .medium:
            return UIFont(name: "PingFangTC-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        case .bold:
            return UIFont(name: "PingFangTC-Semibold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        }
    }
}

extension UITableView {
    func reloadDataSmoothly() {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        
        CATransaction.setCompletionBlock { () -> Void in
            UIView.setAnimationsEnabled(true)
        }
        
        reloadData()
        beginUpdates()
        endUpdates()
        
        CATransaction.commit()
    }
}
