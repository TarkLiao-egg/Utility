import Foundation
import UIKit
import SafariServices
import RxCocoa

enum StoryName: String {
    case main = "Main"
}

class Coordinator {
    static let shared = Coordinator()
    let mainTabPR = PublishRelay<Int>()
    
    static func presentTo<T: UIViewController>(_ current: UIViewController?, _ navType: T.Type, _ storyName: StoryName, isNavigation: Bool = true, beforeAction: ((T) -> (T))? = nil, completion: (() -> Void)? = nil) {
        guard let current = current else { return }
        let storyboardID = String(describing: navType)
        if var vc = UIStoryboard(name: storyName.rawValue, bundle: nil).instantiateViewController(withIdentifier: storyboardID) as? T {
            if let beforeAction = beforeAction {
                vc = beforeAction(vc)
            }
            if isNavigation {
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = .fullScreen
                current.present(navController, animated: true) {
                    completion?()
                }
            } else {
                vc.modalPresentationStyle = .fullScreen
                current.present(vc, animated: true) {
                    completion?()
                }
            }
        }
    }
    
    static func navigateTo<T: UIViewController>(_ current: UIViewController?, _ navType: T.Type, _ storyName: StoryName, beforeAction: ((T) -> (T))? = nil, animated: Bool = true) {
        guard let current = current else { return }
        let storyboardID = String(describing: navType)
        if var vc = UIStoryboard(name: storyName.rawValue, bundle: nil).instantiateViewController(withIdentifier: storyboardID) as? T {
            if let beforeAction = beforeAction {
                vc = beforeAction(vc)
            }
            current.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    static func openSafari(_ vc: UIViewController, url: URL?, completion: (() -> Void)? = nil) {
        guard let url = url else { return }
        let webViewController = SFSafariViewController(url: url)
        vc.present(webViewController, animated: true) {
            completion?()
        }
    }
    
    static func openOutside(url: URL?, completion: (() -> Void)? = nil) {
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { result in
                if result {
                    completion?()
                }
            }
        }
    }
}

extension UIStoryboard {
    static func getController<T: UIViewController>(_ navType: T.Type, _ storyName: StoryName) -> T? {
        let storyboardID = String(describing: navType)
        return UIStoryboard(name: storyName.rawValue, bundle: nil).instantiateViewController(withIdentifier: storyboardID) as? T
    }
}
