import UIKit
//import Combine
//import Moya
@available(iOS 13.0.0, *)
class TestController: UIViewController {
//    var cancelC = [AnyCancellable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "default")
//        withCheckedThrowingContinuation(<#T##body: (CheckedContinuation<T, Error>) -> Void##(CheckedContinuation<T, Error>) -> Void#>)
//        withCheckedContinuation { <#CheckedContinuation<T, Never>#> in
//            <#code#>
//        }
    }
    
    
    func testFunct() async -> Int {
        return await getInt()
    }
    
    func getInt() -> Int {
        sleep(3)
        return 3
    }
//    func handleFlatmap<R:Decodable>(_ json: Any, _ type: R) -> AnyPublisher<R?,MoyaError> {
//        if let dic = json as? [String: Any] {
//            return Deferred {
//                Future { promise in
//                    promise(.success(dic.handleResponse(type: type as! R.Type, comment: "版本") ?? nil))
//                }
//              }.eraseToAnyPublisher()
//        }
//
//        return Deferred {
//            Future { promise in
//              promise(.success(nil))
//            }
//          }.eraseToAnyPublisher()
//    }
     
}
