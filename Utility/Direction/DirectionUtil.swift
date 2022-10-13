import UIKit

class DirectionUtil {
    static let shared = DirectionUtil()
    
    var shouldAutoRotate: Bool = false
    var supportDirection: UIInterfaceOrientationMask = .portrait
    
    func lock(_ direction: UIDeviceOrientation) {
        shouldAutoRotate = true
        UIDevice.current.setValue(direction.rawValue, forKey: "orientation")
        shouldAutoRotate = false
        if direction == .portrait {
            supportDirection = .portrait
        } else {
            supportDirection = .all
        }
    }
    
    func rotate(_ direction: UIDeviceOrientation) {
        shouldAutoRotate = true
        UIDevice.current.setValue(direction.rawValue, forKey: "orientation")
        supportDirection = .all
    }
}
