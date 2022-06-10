import UIKit
//import Combine
//import Moya

class TestController: UIViewController {
//    var cancelC = [AnyCancellable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        WLProvider.request(target: .getAppVersion(dev: "ios"), type: .regular, callbackQueue: .main, isEncrypt: true)
//            .mapJSON()
//            .flatMap({self.handleFlatmap($0, WLVersionInfo.self)})
////            .map(WLVersionInfo.self, atKeyPath: "data")
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    print("finish")
//                case .failure(let err):
//                    print("err:\(err.localizedDescription)")
//                }
//            }, receiveValue: { info in
//                print(info)
//            }).store(in: &cancelC)

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
