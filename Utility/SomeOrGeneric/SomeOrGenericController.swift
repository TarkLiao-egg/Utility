import UIKit
@available(iOS 13.0.0, *)
class SomeOrGenericController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createLogger().log("wdwd")
        
        
        let obj = SomeOrGenericClass()
//        print(getSomeClass(obj: obj) as Any == obj as Any) //Binary operator '==' cannot be applied to operands of type 'some SomeOrGenericClass' and 'SomeOrGenericClass'
        
        
        let log1 = createLogger()
        let log2 = createLogger()
//        if log1 as Any === log2 as Any {
//            // ...
//        }
    }
    
//    func getAnyClass<T: SomeOrGenericClass>() -> T {
//        return T()
//    }
    
    func getSomeClass(obj: some SomeOrGenericClass) -> some SomeOrGenericClass {
        return obj
    }
    
    
    func createLogger() -> Logger {
//        Function declares an opaque return type 'some Logger', but the return statements in its body do not have matching underlying types
//        if isError {
//            return ErrorLogger()
//        } else {
            return ConsoleLogger()
//        }
    }

}

class SomeOrGenericClass {
//    required init() {
//
//    }
}

//class Child: SomeOrGenericClass {
//    let dsd: Int
//}
protocol Logger {
    func log(_ message: String)
}

struct ConsoleLogger: Logger {
    func log(_ message: String) {
        print("[INFO]: \(message)")
    }
}
struct ErrorLogger: Logger {
    func log(_ message: String) {
        print("[ERROR]: \(message)")
    }
}
