//
//  AlertUtil.swift

//
//  Created by Tark on 3/24/22.
//

import Foundation
import UIKit

class AlertUtil {
    static let shared = AlertUtil()
    
    var presentWindow: UIWindow?
    
    
    static func showAlert(_ model: AlertModel) {
        setAlert(model)
    }
    
    static func simpleAlert(title: String, msg: String?) {
        setAlert(AlertModel(type: .single, titleString: title, descriptionString: msg))
    }
    
    static func setAlert(_ model: AlertModel) {
        if let windowScene = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).first as? UIWindowScene {
            shared.presentWindow = UIWindow(windowScene: windowScene)
        }

        shared.presentWindow?.frame = UIScreen.main.bounds
        shared.presentWindow?.backgroundColor = .clear
        shared.presentWindow?.windowLevel = UIWindow.Level.statusBar + 1
        let alert = AlertController(action: {
            shared.presentWindow?.removeFromSuperview()
            shared.presentWindow = nil
        })
        shared.presentWindow?.rootViewController = alert
        shared.presentWindow?.makeKeyAndVisible()
        shared.presentWindow?.alpha = 0
        alert.configure(model)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            shared.presentWindow?.alpha = 1
        }
    }
}
struct AlertModel {
    enum Alert_Type {
        case single
        case mulitiple
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
    
    
    init(type: Alert_Type, isLock: Bool = false, cannotClose: Bool = false, titleString: String, descriptionString: String? = nil, confirmButtonString: String = "確認", cancelButtonString: String = "取消", confirmButtonAction: (() -> Void)? = nil, cancelButtonAction: (() -> Void)? = nil, closeAction: (() -> Void)? = nil) {
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
    }
    
    init(type: Alert_Type, isLock: Bool = false, titleString: String, titleColor: UIColor = primaryTextColor,
         descriptionString: String? = nil, descriptionColor: UIColor = subTextColor,
         confirmButtonString: String = "確認", confirmButtonTextColor: UIColor = UIColor.white, confirmButtonBackgroundColor: UIColor = .black, confirmButtonAction: (() -> Void)? = nil,
         cancelButtonString: String = "取消", cancelButtonTextColor: UIColor = .black, cancelButtonBackgroundColor: UIColor = .black, cancelButtonAction: (() -> Void)? = nil, closeAction: (() -> Void)? = nil) {
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
    }
    
    init(type: Alert_Type, isLock: Bool = false, cannotClose: Bool = false, titleString: String, descriptionString: String? = nil, confirmButtonString: String = "確認", cancelButtonString: String = "取消", alertTitle: String = "", alertDescription: String = "", enterButtonAction: ((String) -> Void)? = nil, cancelButtonAction: (() -> Void)? = nil, closeAction: (() -> Void)? = nil) {
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
    }
    
    init(type: Alert_Type, isLock: Bool = false, titleString: String, titleColor: UIColor = primaryTextColor,
         descriptionString: String? = nil, descriptionColor: UIColor = subTextColor, subTitle: String, subDescription: String? = nil,
         confirmButtonString: String = "確認", confirmButtonTextColor: UIColor = UIColor.white, confirmButtonBackgroundColor: UIColor = .black, confirmButtonAction: (() -> Void)? = nil,
         cancelButtonString: String = "取消", cancelButtonTextColor: UIColor = .black, cancelButtonBackgroundColor: UIColor = .black, cancelButtonAction: (() -> Void)? = nil, closeAction: (() -> Void)? = nil) {
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
    }
}
