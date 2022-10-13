import UIKit

class DirectionController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override var shouldAutorotate: Bool {
        return DirectionUtil.shared.shouldAutoRotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return DirectionUtil.shared.supportDirection
    }
}
