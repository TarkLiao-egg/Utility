import Foundation
import UIKit
import SafariServices
import Combine

enum Main_Tab: Int {
    case home = 0
    case report
    case appoint
    case more
}


@available(iOS 13.0, *)
class CoordinatorCombine {
    static let shared = CoordinatorCombine()
    let mainTabPS = PassthroughSubject<Main_Tab, Error>()
    var mainTabC: AnyCancellable?
    
    static func navTab(_ tab: Main_Tab) {
        shared.mainTabPS.send(tab)
    }
    
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
    
    static func navigateTo<T: UIViewController>(_ current: UIViewController?, _ navType: T, beforeAction: ((T) -> (T))? = nil, animated: Bool = true) {
        var vc = navType
        if let beforeAction = beforeAction {
            vc = beforeAction(vc)
        }
        guard let current = current else { return }
        current.navigationController?.pushViewController(vc, animated: animated)
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
