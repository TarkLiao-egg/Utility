import Foundation
import UIKit

class AlertUtil {
    static let shared = AlertUtil()
    
    var presentWindow: UIWindow?
    var hasAlert: Bool = false
    
    enum Transition {
        case fade
        case up
    }
    
    static func clearAlert(_ transition: Transition = .fade) {
        if transition == .up, let window = shared.presentWindow {
            let springMoveLeftAnimation = CABasicAnimation(keyPath: "position.y")
            springMoveLeftAnimation.fromValue = window.frame.height * 0.5
            springMoveLeftAnimation.toValue = window.frame.height * 1.5
            springMoveLeftAnimation.duration = 0.3
            springMoveLeftAnimation.fillMode = .forwards
            springMoveLeftAnimation.isRemovedOnCompletion = false
            springMoveLeftAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            shared.presentWindow?.layer.add(springMoveLeftAnimation, forKey: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                shared.presentWindow?.removeFromSuperview()
                shared.presentWindow = nil
                shared.hasAlert = false
            }
        } else {
            shared.presentWindow?.removeFromSuperview()
            shared.presentWindow = nil
            shared.hasAlert = false
        }
    }
    
    static func showAlert(_ model: AlertModel) {
        setAlert(model)
    }
    
    static func simpleAlert(title: String, msg: String?) {
        setAlert(AlertModel(type: .single, titleString: title, descriptionString: msg))
    }
    
    static func setAlert(_ model: AlertModel, transition: Transition = .fade) {
        DispatchQueue.main.asyncAfter(deadline: .now() + (shared.hasAlert ? 0.3 : 0)) {
            if #available(iOS 13.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).first as? UIWindowScene {
                    shared.presentWindow = UIWindow(windowScene: windowScene)
                }
            } else {
                shared.presentWindow = UIWindow()
            }
            
            guard let _ = shared.presentWindow else {
                // recursive
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    setAlert(model, transition: transition)
                }
                return
            }
            shared.presentWindow?.frame = UIScreen.main.bounds
            shared.presentWindow?.backgroundColor = .clear
            shared.presentWindow?.windowLevel = UIWindow.Level.statusBar + 1
            let alert: AlertController
            switch model.type {
            case .single:
                alert = SingleAlertController(action: {
                    AlertUtil.clearAlert()
                })
            case .mulitiple:
                alert = MulitipleAlertController(action: {
                    AlertUtil.clearAlert()
                })
            case .editData:
                alert = EditDataController(action: {
                    AlertUtil.clearAlert(.up)
                })
            default:
                alert = MulitipleAlertController(action: {
                    AlertUtil.clearAlert()
                })
            }
            shared.presentWindow?.rootViewController = alert
            shared.presentWindow?.makeKeyAndVisible()
            alert.configure(model)
            shared.hasAlert = true
            switch transition {
            case .fade:
                let springMoveLeftAnimation = CABasicAnimation(keyPath: "opacity")
                springMoveLeftAnimation.fromValue = 0
                springMoveLeftAnimation.toValue = 1
                springMoveLeftAnimation.duration = 0.3
                springMoveLeftAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                shared.presentWindow?.layer.add(springMoveLeftAnimation, forKey: nil)
            case .up:
                let springMoveLeftAnimation = CABasicAnimation(keyPath: "position.y")
                springMoveLeftAnimation.fromValue = shared.presentWindow!.frame.height * 1.5
                springMoveLeftAnimation.toValue = shared.presentWindow!.frame.height * 0.5
                springMoveLeftAnimation.duration = 0.3
                springMoveLeftAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                shared.presentWindow?.layer.add(springMoveLeftAnimation, forKey: nil)
            }
        }
    }
}
struct AlertModel {
    enum Alert_Type {
        case single
        case mulitiple
        case editData
        case editAppoint
    }
    static let primaryTextColor: UIColor = UIColor.white
    static let subTextColor: UIColor = UIColor.white
    
    var type: Alert_Type = .single
    var isLock: Bool = false
    var cannotClose: Bool = false
    var titleString: String = ""
    var titleColor: UIColor = primaryTextColor
    var descriptionString: String? = nil
    var descriptionColor: UIColor = subTextColor
    var subTitleString: String = ""
    var subDescriptionString: String? = nil
    
    var confirmButtonString: String = "確認"
    var confirmButtonTextColor: UIColor = UIColor.white
    var confirmButtonBackgroundColor: UIColor = .black
    var confirmButtonAction: (() -> Void)? = nil
    var alertTitleString: String = ""
    var alertDescriptionString: String = ""
    var enterButtonAction: ((String) -> Void)? = nil
    
    var cancelButtonString: String = "取消"
    var cancelButtonTextColor: UIColor = .black
    var cancelButtonBackgroundColor: UIColor = .black
    var cancelButtonAction: (() -> Void)? = nil
    var closeAction: (() -> Void)? = nil
    var anyAction: [((Any?) -> Void)] = []
    var any: Any?
    
    
    init(type: Alert_Type, isLock: Bool = false, cannotClose: Bool = false, titleString: String, descriptionString: String? = nil, confirmButtonString: String = "Yes", cancelButtonString: String = "No", confirmButtonAction: (() -> Void)? = nil, cancelButtonAction: (() -> Void)? = nil, closeAction: (() -> Void)? = nil, anyAction: [((Any?) -> Void)] = [], any: Any? = nil) {
        self.type = type
        self.isLock = isLock
        self.cannotClose = cannotClose
        self.titleString = titleString
        self.descriptionString = descriptionString
        self.confirmButtonString = confirmButtonString
        self.confirmButtonAction = confirmButtonAction
        self.cancelButtonString = cancelButtonString
        self.cancelButtonAction = cancelButtonAction
        self.closeAction = closeAction
        self.anyAction = anyAction
        self.any = any
    }
    
    init(type: Alert_Type, isLock: Bool = false, titleString: String, titleColor: UIColor = primaryTextColor,
         descriptionString: String? = nil, descriptionColor: UIColor = subTextColor,
         confirmButtonString: String = "Yes", confirmButtonTextColor: UIColor = UIColor.white, confirmButtonBackgroundColor: UIColor = .black, confirmButtonAction: (() -> Void)? = nil,
         cancelButtonString: String = "No", cancelButtonTextColor: UIColor = .black, cancelButtonBackgroundColor: UIColor = .black, cancelButtonAction: (() -> Void)? = nil, closeAction: (() -> Void)? = nil, anyAction: [((Any?) -> Void)] = [], any: Any? = nil) {
        self.type = type
        self.isLock = isLock
        self.titleString = titleString
        self.titleColor = titleColor
        self.descriptionString = descriptionString
        self.descriptionColor = descriptionColor
        self.confirmButtonString = confirmButtonString
        self.confirmButtonTextColor = confirmButtonTextColor
        self.confirmButtonBackgroundColor = confirmButtonBackgroundColor
        self.confirmButtonAction = confirmButtonAction
        self.cancelButtonString = cancelButtonString
        self.cancelButtonTextColor = cancelButtonTextColor
        self.cancelButtonBackgroundColor = cancelButtonBackgroundColor
        self.cancelButtonAction = cancelButtonAction
        self.closeAction = closeAction
        self.anyAction = anyAction
        self.any = any
    }
    
    init(type: Alert_Type, isLock: Bool = false, cannotClose: Bool = false, titleString: String, descriptionString: String? = nil, confirmButtonString: String = "Yes", cancelButtonString: String = "No", alertTitle: String = "", alertDescription: String = "", enterButtonAction: ((String) -> Void)? = nil, cancelButtonAction: (() -> Void)? = nil, closeAction: (() -> Void)? = nil, anyAction: [((Any?) -> Void)] = [], any: Any? = nil) {
        self.type = type
        self.isLock = isLock
        self.cannotClose = cannotClose
        self.titleString = titleString
        self.descriptionString = descriptionString
        self.confirmButtonString = confirmButtonString
        self.alertTitleString = alertTitle
        self.alertDescriptionString = alertDescription
        self.enterButtonAction = enterButtonAction
        self.cancelButtonString = cancelButtonString
        self.cancelButtonAction = cancelButtonAction
        self.closeAction = closeAction
        self.anyAction = anyAction
        self.any = any
    }
    
    init(type: Alert_Type, isLock: Bool = false, titleString: String, titleColor: UIColor = primaryTextColor,
         descriptionString: String? = nil, descriptionColor: UIColor = subTextColor, subTitle: String, subDescription: String? = nil,
         confirmButtonString: String = "Yes", confirmButtonTextColor: UIColor = UIColor.white, confirmButtonBackgroundColor: UIColor = .black, confirmButtonAction: (() -> Void)? = nil,
         cancelButtonString: String = "No", cancelButtonTextColor: UIColor = .black, cancelButtonBackgroundColor: UIColor = .black, cancelButtonAction: (() -> Void)? = nil, closeAction: (() -> Void)? = nil, anyAction: [((Any?) -> Void)] = [], any: Any? = nil) {
        self.type = type
        self.isLock = isLock
        self.titleString = titleString
        self.titleColor = titleColor
        self.descriptionString = descriptionString
        self.descriptionColor = descriptionColor
        self.subTitleString = subTitle
        self.subDescriptionString = subDescription
        self.confirmButtonString = confirmButtonString
        self.confirmButtonTextColor = confirmButtonTextColor
        self.confirmButtonBackgroundColor = confirmButtonBackgroundColor
        self.confirmButtonAction = confirmButtonAction
        self.cancelButtonString = cancelButtonString
        self.cancelButtonTextColor = cancelButtonTextColor
        self.cancelButtonBackgroundColor = cancelButtonBackgroundColor
        self.cancelButtonAction = cancelButtonAction
        self.closeAction = closeAction
        self.anyAction = anyAction
        self.any = any
    }
}
