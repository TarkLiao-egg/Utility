import Foundation
import UIKit

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
    
    @discardableResult
    func setV(_ closure: (Self) -> Void, _ parent: inout UIView, _ closureUI: (Self) -> Void) -> Self {
        closure(self)
        if let view = self as? UIView {
            parent.addSubview(view)
            closureUI(self)
        }
        return self
    }
    
    @discardableResult
    func setS(_ closure: (Self) -> Void, _ closureUI: (Self) -> Void) -> Self {
        closure(self)
        closureUI(self)
        return self
    }
}

#if canImport(SnapKit)
import SnapKit
extension OP_Declarative {
    @discardableResult
    func VS(_ closure: ((Self) -> Void)? = nil, _ parent: UIView, _ closureUI: (_ make: ConstraintMaker) -> Void) -> Self {
        closure?(self)
        if let view = self as? UIView {
            parent.addSubview(view)
            if let myself = self as? UIView {
                myself.snp.makeConstraints { make in
                    closureUI(make)
                }
            }
        }
        
        return self
    }
    
    @discardableResult
    func S(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
    
    @discardableResult
    func SS(_ closure: (Self) -> Void, _ closureUI: ((_ make: ConstraintMaker) -> Void)? = nil) -> Self {
        closure(self)
        if let myself = self as? UIView, let closureUI = closureUI {
            myself.snp.makeConstraints { make in
                closureUI(make)
            }
        }
        return self
    }
}
#endif

extension NSObject: OP_Declarative {}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIImageView {
    static func name(_ name: String) -> UIImageView {
        var image = UIImage(named: name)
        image = image?.withRenderingMode(.alwaysOriginal)
        return UIImageView(image: image)
    }
    
    static func renderName(_ name: String, color: UIColor) -> UIImageView {
        var image = UIImage(named: name)
        image = image?.withRenderingMode(.alwaysTemplate)
        let imgView = UIImageView(image: image)
        imgView.tintColor = color
        return imgView
    }
}

extension UIColor {
    convenience init(_ hex: Int, alpha: Double = 1.0) {
        self.init(red: Double((hex & 0xff0000) >> 16) / 255.0,
                  green: Double((hex & 0xff00) >> 8) / 255.0,
                  blue: Double((hex & 0xff) >> 0) / 255.0,
                  alpha: alpha)
    }
}

extension String {
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func rangeString(_ range: NSRange) -> String? {
        if let range = Range(range, in: self) {
            return String(self[range])
        } else {
            return nil
        }
    }
}

extension Int {
    func getDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

extension Date {
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func getFormatString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getDateTimeStringAMPM(_ isUpper: Bool = false) -> String {
        let hourString = getFormatString(format: "HH")
        var amPm = "am"
        guard var hours = Int(hourString) else {
            return ""
        }
        if hours > 12 {
            amPm = "pm"
            hours -= 12
        }
        amPm = isUpper ? amPm.uppercased() : amPm.lowercased()
        return String(format: "%02d", hours) + getFormatString(format: ":mm ") + amPm
    }
    
    func getDateShowString() -> String {
        //    Decmber 20, 2022
        let month: String
        switch self.getDateInfo(option: .month) {
        case 1:
            month = "January"
        case 2:
            month = "February"
        case 3:
            month = "March"
        case 4:
            month = "April"
        case 5:
            month = "May"
        case 6:
            month = "June"
        case 7:
            month = "July"
        case 8:
            month = "August"
        case 9:
            month = "September"
        case 10:
            month = "October"
        case 11:
            month = "November"
        case 12:
            month = "December"
        default:
            month = ""
        }
        return "\(month) \(self.getDateInfo(option: .day)), \(self.getDateInfo(option: .year))"
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
        case .second:
            return Calendar.current.dateComponents([option], from: self).second ?? 0
        case .weekday:
            let day = Calendar.current.dateComponents([option], from: self).weekday ?? 0
            if day == 1 {
                return 7
            } else {
                return day - 1
            }
        default:
            return -1
        }
    }
    
    func getDateComponents() -> DateComponents {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.year = self.getDateInfo(option: .year)
        components.month = self.getDateInfo(option: .month)
        components.day = self.getDateInfo(option: .day)
        components.hour = self.getDateInfo(option: .hour)
        components.minute = self.getDateInfo(option: .minute)
        components.second = self.getDateInfo(option: .second)
        return components
    }
    
    func setDateComponents(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> DateComponents {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.year = year == nil ? self.getDateInfo(option: .year) : year
        components.month = month == nil ? self.getDateInfo(option: .month) : month
        components.day = day == nil ? self.getDateInfo(option: .day) : day
        components.hour = hour == nil ? self.getDateInfo(option: .hour) : hour
        components.minute = minute == nil ? self.getDateInfo(option: .minute) : minute
        components.second = second == nil ? self.getDateInfo(option: .second) : second
        return components
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
    func setProperty(_ color: UIColor, _ fontStyle: UIFont.FontStyle = .medium, _ size: CGFloat, _ str: String? = nil, _ align: NSTextAlignment = .left) {
        self.font = UIFont.getDefaultFont(fontStyle, size: size)
        self.textAlignment = align
        self.textColor = color
        self.text = str
    }
    
    var isBlank: Bool {
        guard let text = self.text else { return true }
        return text.replacingOccurrences(of: " ", with: "") == ""
    }
    
    func addDoneButtonOnKeyboard(_ target: UIViewController? = nil, doneSelector: Selector? = nil, clearSelector: Selector? = nil) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
        if let doneSelector = doneSelector {
            done.action = doneSelector
            done.target = target
        } else {
            done.action = #selector(doneButtonAction)
        }

        done.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .normal)
        done.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .selected)
        var items = [flexSpace, done]
        if let clearSelector = clearSelector {
            let del: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
            del.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .normal)
            del.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .selected)
            del.action = clearSelector
            del.target = target
            items.insert(del, at: 0)
        }
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    static func setMaxLength(_ textField: UITextField,_ range: NSRange,_ replacementString: String, length: Int) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + replacementString.count
        return count <= length
    }
}

#if canImport(Combine)
import Combine
@available(iOS 13.0, *)
extension UITextField {
    func addDoneButtonOnKeyboard(doneClosure: ((UITextField) -> Void)? = nil, clearClosure: ((UITextField) -> Void)? = nil, cancelC: inout [AnyCancellable]) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
        
        if let doneClosure = doneClosure {
            done.getPublisher().sink { [weak self] _ in
                guard let self = self else { return }
                self.resignFirstResponder()
                doneClosure(self)
            }.store(in: &cancelC)
        } else {
            done.action = #selector(doneButtonAction)
        }

        done.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .normal)
        done.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .selected)
        var items = [flexSpace, done]
        if let clearClosure = clearClosure {
            let del: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
            del.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .normal)
            del.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .selected)
            done.getPublisher().sink { [weak self] _ in
                guard let self = self else { return }
                self.resignFirstResponder()
                clearClosure(self)
            }.store(in: &cancelC)
            items.insert(del, at: 0)
        }
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
}
#endif

extension UILabel {
    func setProperty(_ color: UIColor, _ fontStyle: UIFont.FontStyle = .medium, _ size: CGFloat, _ str: String? = nil, _ align: NSTextAlignment = .left, _ numLine: Int = 1) {
        self.font = UIFont.getDefaultFont(fontStyle, size: size)
        self.textAlignment = align
        self.textColor = color
        self.text = str
        self.numberOfLines = numLine
    }
    
    func textWidth() -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.size.width
    }
    
    func fontToFitHeight(min: CGFloat = 3, max: CGFloat = 70) {
        var minFontSize: CGFloat = min
        var maxFontSize: CGFloat = max
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        let labelHeight = self.frame.size.height
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            // Abort if text happens to be nil
            guard let text = self.text, text.count > 0 else {
                break
            }
            if let labelText: NSString = text as NSString? {
                
                let testStringHeight = labelText.size(withAttributes: [NSAttributedString.Key.font: self.font.withSize(fontSizeAverage)]).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        self.font = self.font.withSize(fontSizeAverage - 1)
                        return
                    }
                    self.font = self.font.withSize(fontSizeAverage)
                    return
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    self.font = self.font.withSize(fontSizeAverage)
                    return
                }
            }
        }
        self.font = self.font.withSize(fontSizeAverage)
        return
    }
    
    func fontToFitWidth(min: CGFloat = 2, max: CGFloat = 70) {
        var minFontSize: CGFloat = min
        var maxFontSize: CGFloat = max
        var fontSizeAverage: CGFloat = 0
        var textAndLabelWidthDiff: CGFloat = 0
        let labelWidth = self.frame.size.width
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            // Abort if text happens to be nil
            guard let text = self.text, text.count > 0 else {
                break
            }
            if let labelText: NSString = text as NSString? {
                
                let testStringWidth = labelText.size(withAttributes: [NSAttributedString.Key.font: self.font.withSize(fontSizeAverage)]).width
                
                textAndLabelWidthDiff = labelWidth - testStringWidth
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelWidthDiff < 0) {
                        self.font = self.font.withSize(fontSizeAverage - 1)
                        return
                    }
                    self.font = self.font.withSize(fontSizeAverage - 1)
                    return
                }
                
                if (textAndLabelWidthDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelWidthDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    self.font = self.font.withSize(fontSizeAverage - 1)
                    return
                }
            }
        }
        self.font = self.font.withSize(fontSizeAverage - 1)
        return
    }
    
    func getFontToFitWidth(min: CGFloat = 2, max: CGFloat = 70, labelWidth: CGFloat) -> CGFloat {
        var minFontSize: CGFloat = min
        var maxFontSize: CGFloat = max
        var fontSizeAverage: CGFloat = 0
        var textAndLabelWidthDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            // Abort if text happens to be nil
            guard let text = self.text, text.count > 0 else {
                break
            }
            if let labelText: NSString = text as NSString? {
                
                let testStringWidth = labelText.size(withAttributes: [NSAttributedString.Key.font: self.font.withSize(fontSizeAverage)]).width
                
                textAndLabelWidthDiff = labelWidth - testStringWidth
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelWidthDiff < 0) {
                        return fontSizeAverage - 1
                    }
                    return fontSizeAverage
                }
                
                if (textAndLabelWidthDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelWidthDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return fontSizeAverage
                }
            }
        }
        return fontSizeAverage
    }
}

extension UITextView {
    func setProperty(_ color: UIColor, _ fontStyle: UIFont.FontStyle = .medium, _ size: CGFloat, _ str: String? = nil, _ align: NSTextAlignment = .left) {
        self.font = UIFont.getDefaultFont(fontStyle, size: size)
        self.textAlignment = align
        self.textColor = color
        self.text = str
    }
    
    var isBlank: Bool {
        guard let text = self.text else { return true }
        return text.replacingOccurrences(of: " ", with: "") == ""
    }
    
    func addDoneButtonOnKeyboard(_ target: UIViewController? = nil, doneSelector: Selector? = nil, clearSelector: Selector? = nil) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
        if let doneSelector = doneSelector {
            done.action = doneSelector
            done.target = target
        } else {
            done.action = #selector(doneButtonAction)
        }

        done.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .normal)
        done.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .selected)
        var items = [flexSpace, done]
        if let clearSelector = clearSelector {
            let del: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
            del.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .normal)
            del.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangTC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.underlineColor: UIColor.clear], for: .selected)
            del.action = clearSelector
            del.target = target
            items.insert(del, at: 0)
        }
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
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

import Combine
import CoreMedia
@available(iOS 13.0, *)
final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

@available(iOS 13.0, *)
struct UIControlPublisher<Control: UIControl>: Publisher {

    typealias Output = Control
    typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

protocol CombineCompatible { }
extension UIControl: CombineCompatible { }
@available(iOS 13.0, *)
extension CombineCompatible where Self: UIControl {
    func getPublisher(for events: UIControl.Event) -> UIControlPublisher<Self> {
        return UIControlPublisher(control: self, events: events)
    }
}

@available(iOS 13.0, *)
final class UIBarButtonItemSubscription<SubscriberType: Subscriber, Control: UIBarButtonItem>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control) {
        self.subscriber = subscriber
        self.control = control
        control.target = self
        control.action = #selector(eventHandler)
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

@available(iOS 13.0, *)
struct UIBarButtonItemPublisher<Control: UIBarButtonItem>: Publisher {

    typealias Output = Control
    typealias Failure = Never

    let control: Control

    init(control: Control) {
        self.control = control
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIBarButtonItemPublisher.Failure, S.Input == UIBarButtonItemPublisher.Output {
        let subscription = UIBarButtonItemSubscription(subscriber: subscriber, control: control)
        subscriber.receive(subscription: subscription)
    }
}

extension UIBarItem: CombineCompatible { }
@available(iOS 13.0, *)
extension CombineCompatible where Self: UIBarButtonItem {
    func getPublisher() -> UIBarButtonItemPublisher<Self> {
        return UIBarButtonItemPublisher(control: self)
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(UUID().uuidString.prefix(15)), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIBarButtonItem {
    static func getButton( _ closure: @escaping()->()) -> UIBarButtonItem {
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        let btn = UIBarButtonItem(title: "test", style: .plain, target: sleeve, action: #selector(ClosureSleeve.invoke))
        objc_setAssociatedObject(self, String(UUID().uuidString.prefix(15)), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        return btn
    }
}
