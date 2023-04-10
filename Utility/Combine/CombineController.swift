import UIKit
import Combine

struct TestStruct {
    var int = 0
}

class TestClass {
    var int = 0
}

@available(iOS 13.0, *)
class CombineController: UIViewController {
    var cancelC = [AnyCancellable]()
    let intCVS = CurrentValueSubject<Int, Never>(0)
    let structCVS = CurrentValueSubject<TestStruct, Never>(TestStruct())
    let classCVS = CurrentValueSubject<TestClass, Error>(TestClass())
    let label = UILabel()
    
    var cancel: Subscription?
    @Published var intValue: Int = 2
    @Published var addValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        
        
        let sss = MySubscriber()
        sss.getSubscription { [weak self] subscription in
            self?.cancel = subscription
        }
        $addValue.subscribe(sss)
//            .subscribe(MySubscriber())
        print(cancel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            print(self?.cancel)
            self?.cancel?.cancel()
        }
    }
    
    func bind() {
        let btn = UIButton()
        btn.getPublisher(for: .touchUpInside).sink { btn in
            print("btn press")
        }.store(in: &cancelC)
        
        $intValue.sink { data in
            print(data)
        }.store(in: &cancelC)
        intCVS
            .map({"\($0)"})
            .assign(to: \.text, on: label)
            .store(in: &cancelC)
        intCVS.sink { _ in
        } receiveValue: { int in
            print("int:\(int)")
        }.store(in: &cancelC)
        
        structCVS.sink { _ in
        } receiveValue: { int in
            print("struct:\(int.int)")
        }.store(in: &cancelC)
    
        classCVS.sink { _ in
        } receiveValue: { int in
            print("class:\(int.int)")
        }.store(in: &cancelC)
        
        $addValue.scan(-1, {
            print("before\($0)")
            print("after:\($1)")
            return $1
        }).sink { data in
            print("data:\(data)")
        }.store(in: &cancelC)
    }
}

@available(iOS 13.0, *)
extension CombineController {
    func setupButton() {
        
    }
    
    @objc func sendButtonPressed() {
        intCVS.send(1)
        structCVS.send(TestStruct(int: 1))
        classCVS.send(TestClass())
    }
    
    @objc func addButtonPressed() {
        intCVS.value += 1
        structCVS.value.int += 1
        classCVS.value.int += 1
        print(classCVS.value.int)
        addValue += 1
    }
}

@available(iOS 13.0, *)
extension CombineController {
    func setupUI() {
        let btn = UIButton()
        btn.forSelf {
            $0.setTitle("Send", for: .normal)
            $0.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        }
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let btn2 = UIButton()
        btn2.forSelf {
            $0.setTitle("Add", for: .normal)
            $0.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        }
        view.addSubview(btn2)
        btn2.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    class MySubscriber: Subscriber {
        typealias Input = Int // 設置訂閱的流的輸入類型為 String
        typealias Failure = Never // 設置錯誤類型為 Error
        
        var action: ((Subscription?) -> Void)?
        
        func receive(subscription: Subscription) {
            print("first")
            subscription.request(.unlimited) // 設置訂閱流的需求為不限量
            action?(subscription)
        }
        
        func receive(_ input: Int) -> Subscribers.Demand {
            print("Received input: \(input)")
            return .unlimited // 設置返回的需求為不限量
        }
        
        func receive(completion: Subscribers.Completion<Never>) {
            switch completion {
            case .finished:
                print("Subscription completed successfully")
            case .failure(let error):
                print("Subscription completed with an error: \(error.localizedDescription)")
            }
        }
        
        func getSubscription(closure: @escaping (Subscription?) -> Void) {
            action = closure
        }
    }
}
