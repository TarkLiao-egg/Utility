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
    
    @Published var intValue: Int = 2
    @Published var addValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
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
}
