import UIKit

class PropertyNameController: UIViewController {
    class TestClass {
        var data: String = "data"
        @objc var nabamTake: Int = 0
        func getTakeName() -> String {
            return #keyPath(nabamTake)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let s = TestClass()
        print(s.getTakeName()) // nabamTake
        
        let mirror = Mirror(reflecting: s)
        for (_, attr) in mirror.children.enumerated() {
            if let name = attr.label {
                print("\(name) = \(unwrap(attr.value))")
            }
        }
    }
    
    //将可选类型（Optional）拆包
    func unwrap(_ any:Any) -> Any {
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
         
        if mi.children.count == 0 { return any }
        let (_, some) = mi.children.first!
        return some
    }
}
