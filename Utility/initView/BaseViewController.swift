import UIKit

protocol Controller {
    associatedtype ViewType
    var currentView: ViewType { get }
}

class BaseViewController<ViewType: UIView>: UIViewController, Controller {
  
    override func loadView() {
        self.view = ViewType()
    }
  
    var currentView: ViewType {
        if let view = self.view as? ViewType {
            return view
        } else {
            let view = ViewType()
            self.view = view
            return view
        }
    }
}
