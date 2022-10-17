import Foundation
import UIKit
//Protocols with Associated Types (PATs)
//https://www.appcoda.com.tw/swift-polymorphism/

class PATController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0.0, *) {
            test_opaqueType()
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func classGeneric() {
        let dos = DoSometing<Int>()
        dos.append(x: 1, y: 2)
    }
    
    
}
class DoSometing<Number> {
    
    func append<Number>(x: Number, y: Number) -> [Number] {
        return [x, y]
    }
}


// MARK: Opaque
protocol Number {}

extension Int: Number {}
extension Double: Number {}

extension PATController {
    
    @available(iOS 13.0.0, *)
    func test_opaqueType() {
        var array = [Number]()
        for _ in 0...3 {
            array.append(getNumber())
            array.append(getNumber3())
        }
        debugPrint(getNumber())
        
        let ad: [Any] = [getNumber(), getNumber3()]
        print(ad)
    }
    
    @available(iOS 13.0.0, *)
    func getNumber() -> some Number {
        return 23
    }
    
    
    @available(iOS 13.0.0, *)
    func getNumber3() -> some Number {
        return 23
    }
}

protocol Burger {
//    var bread: String { get set }
//    var veg: String { get set }
//    var cheese: String { get set }
//    var meet: String { get set }
}
struct McDonaldsBurger: Burger{}
struct BurgerKingBurger: Burger{}
@available(iOS 13.0.0, *)
func getBurger(by isMM: Bool) -> some Burger{
    if isMM {
        return McDonaldsBurger()
    } else {
        return BurgerKingBurger()
    }
}
func getBurger(by isMM: Bool) -> Burger{
    if isMM {
        return McDonaldsBurger()
    } else {
        return BurgerKingBurger()
    }
}







// MARK: Subtyping vs Generic programming
protocol Shooter {
    func shoot()
}
extension Shooter {
    func shoot() {
        print("shoot")
    }
}

struct ShooterA: Shooter {
    var testA: String = "A"
}
struct ShooterB: Shooter {
    var testB: String = "B"
}

extension PATController {
    func Subtyping_VS_GenericProgramming() {
//        success: because Subtyping check on runtime
        duelC(shooterA: ShooterA(), shooterB: ShooterB())
//        error: because Generic programming check on compiler
//        duelD(shooterA: ShooterA(), shooterB: ShooterB())
    }
    
    // Subtyping
    func duelC(shooterA: Shooter, shooterB: Shooter) { /* ... */ }

    // Generic programming
    func duelD<T: Shooter>(shooterA: T, shooterB: T) { /* ... */ }
}



// MARK: Example1
protocol AssociateProtocol {
   associatedtype AssType
   func buyFoodForMe(myHandyMan: AssType)
}
struct TaiwanPrince {
    let food: String
    func buyFood() {
        print(food)
    }
}

struct TaiwanKing: AssociateProtocol {
   typealias HandyMan = TaiwanPrince
   func buyFoodForMe(myHandyMan: TaiwanPrince) {
      myHandyMan.buyFood()
   }
}
struct TaiwanPrincess: AssociateProtocol {
   typealias HandyMan = TaiwanPrince
   func buyFoodForMe(myHandyMan: TaiwanPrince) {
      myHandyMan.buyFood()
   }
}

// MARK: Class Inheritance
class Taiwan<AssType>: AssociateProtocol {
    func buyFoodForMe(myHandyMan: AssType) {
        
    }
}

class TaiwanContainer<ConcreteType: AssociateProtocol>: Taiwan<ConcreteType.AssType> {
    private var instance: ConcreteType

    init(_ base: ConcreteType) {
        self.instance = base
    }

    // 將對 execute(handler:) 的呼叫引導給 instance。
    override func buyFoodForMe(myHandyMan: ConcreteType.AssType) {
        instance.buyFoodForMe(myHandyMan: myHandyMan)
    }
}

extension PATController {
    func Example1_ClassInheritance() {
        let snowWhite = TaiwanContainer(TaiwanPrincess())
        let snowKing = TaiwanContainer(TaiwanKing())
        let princesss: [Taiwan] = [snowWhite, snowKing]
        for princess in princesss {
            princess.buyFoodForMe(myHandyMan: TaiwanPrince(food: "買珍珠奶茶"))
        }
    }
}


// MARK: Witness Table
struct TaiwanWitness<AssType>: AssociateProtocol {
    
    // Concrete type 的實體。
    private(set) var instance: Any

    // Concrete type 的成員 getter。
    private let instance_execute: (Any) -> (AssType) -> Void

    // Concrete type 是甚麼，只有在 initializer 裡才知道，也就是這裡的 generic type T。
    init<T: AssociateProtocol>(_ instance: T) where T.AssType == AssType {

        self.instance = instance

        self.instance_execute = { instance in

            // 因為只有在這個 initializer 裡面才能設定 self.instance 的型別，所以可以確定之後傳入的 instance 一定是 T，可以強制 cast。
            return (instance as! T).buyFoodForMe(myHandyMan:)
        }
    }
    func buyFoodForMe(myHandyMan: AssType) {
        let method = instance_execute(instance)

        // 執行 method。
        method(myHandyMan)
    }
}

extension PATController {
    func Example1_WitnessTable() {
        let witness: [TaiwanWitness] = [TaiwanWitness(TaiwanKing()), TaiwanWitness(TaiwanPrincess())]
        
        for item in witness {
            item.buyFoodForMe(myHandyMan: TaiwanPrince(food: "買珍珠奶茶"))
        }
    }
}



// MARK: Example2
struct HTTPCall {

    var request: URLRequest

    var session: URLSession = .shared

    func execute(handler: @escaping (Result<Data, Error>) -> Void) {
        // 實作...
    }
}

struct LoadFileOperation {

    var fileURL: URL

    var manager: FileManager = .default

    func execute(handler: @escaping (Result<Data, Error>) -> Void) {
        // 實作...
    }
}

protocol Executable {
    associatedtype Response
    func execute(handler: @escaping (Response) -> Void)
}

extension HTTPCall: Executable {
    // Compiler 可以自動解析出 Response 的 concrete type，所以以下這行可省略。
//    typealias Response = Result<Data, Error>
}

extension LoadFileOperation: Executable {
    // 同樣可省略。
//    typealias Response = Result<Data, Error>
}


// MARK: Type Erasure：用 Class Inheritance 解決
class ExecutableClassInheritance<Response>: Executable {

    func execute(handler: @escaping (Response) -> Void) {
        fatalError("未實作。")
    }
}

// 實際儲存實體與 concrete type 資訊的 subclass。
class ExecutableClassInheritanceContainer<ConcreteType: Executable>: ExecutableClassInheritance<ConcreteType.Response> {

    private var instance: ConcreteType

    init(_ base: ConcreteType) {
        self.instance = base
    }

    // 將對 execute(handler:) 的呼叫引導給 instance。
    override func execute(handler: @escaping (ConcreteType.Response) -> Void) {
        instance.execute(handler: handler)
    }
}


// MARK: Type Erasure：手作 Witness Table
struct ExecutableWitnessTable<Response>: Executable {

    // Concrete type 的實體。
    private(set) var instance: Any

    // Concrete type 的成員 getter。
    private let instance_execute: (Any) -> (@escaping (Response) -> Void) -> Void

    // Concrete type 是甚麼，只有在 initializer 裡才知道，也就是這裡的 generic type T。
    init<T: Executable>(_ instance: T) where T.Response == Response {

        self.instance = instance

        self.instance_execute = { instance in

            // 因為只有在這個 initializer 裡面才能設定 self.instance 的型別，所以可以確定之後傳入的 instance 一定是 T，可以強制 cast。
            (instance as! T).execute(handler:)
        }
    }

    func execute(handler: @escaping (Response) -> Void) {

        // 取得 self.instance 的 execute(handler:) method。
        let method = instance_execute(instance)

        // 執行 method。
        method(handler)
    }
}

extension PATController {
    
    func patExample() {
        let call1: ExecutableClassInheritance = ExecutableClassInheritanceContainer(HTTPCall(request: URLRequest(url: URL(string: "")!)))
        let call2 = ExecutableClassInheritanceContainer(LoadFileOperation(fileURL: URL(string: "")!)) as ExecutableClassInheritance

        // 只要這些 AnyExecutable 的 Response 是同樣的 type，它們就可以被放到同一個 collection 裡面。
        let _ = [call1, call2]
        
        
        let call3 = ExecutableWitnessTable(HTTPCall(request: URLRequest(url: URL(string: "")!)))
        let call4 = ExecutableWitnessTable(LoadFileOperation(fileURL: URL(string: "")!))
        let _ = [call3, call4]
    }
}
