import UIKit
import Combine
import RxSwift
//import Moya


@available(iOS 13.0, *)
class TestController: UIViewController {
    var cancelC = [AnyCancellable]()
    var lableView: AnimateLabelView!
    var randomButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        lableView = AnimateLabelView(font: UIFont.getDefaultFont(.regular, size: 40), size: 40, textColor: UIColor.hex(0xff0000)).VS({
        

    }
    
//    func testResponse() {
//        print("viewController testResponse")
////        next?.testResponse()
//    }
}

@available(iOS 13.0, *)
extension TestController {
    func setupButton() {
        randomButton.addTarget(nil, action: #selector(testAction), for: .touchUpInside)
//        randomButton.getPublisher(for: .touchUpInside).sink { [unowned self] _ in
//            lableView.animate(String(Int.random(in: 0...1099999)))
//            testResponse()
//        }.store(in: &cancelC)
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
    @objc func testAction() {
    }
}
