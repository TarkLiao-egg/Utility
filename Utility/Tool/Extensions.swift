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

extension UITextView {
    
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
    func getPublisher(for events: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, events: events)
    }
}
