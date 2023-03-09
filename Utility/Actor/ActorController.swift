import UIKit

@available(iOS 13.0.0, *)
class ActorController: UIViewController {
    var classVarible: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let actorModel = ActorModel()
        Task {
            for i in 1...10 {
                await actorModel.appendArray(i)
                await print(actorModel.array.sorted())
            }
        }
        Task {
            for i in 21...30 {
                await actorModel.appendArray(i)
                await print(actorModel.array.sorted())
            }
        }
        
        Task {
            for i in 11...20 {
                await actorModel.appendArray(i)
                await print(actorModel.array.sorted())
            }
        }
        
        Task {
            async let data = actorModel.setMute(23)
            print(await data)
            print(actorModel.immuteValue)
//            print(await actorModel.array.append(23)) // Actor-isolated property 'array' can not be mutated from the main actor
            print(await actorModel.commonClass)
            await actorModel.commonClass.varible = 2
            actorModel.stylizedName.addAttributes( [NSAttributedString.Key.foregroundColor: UIColor.green], range: NSRange(location: 2, length: 2))
            print(actorModel.stylizedName)
            var localVarible: Int = 0
            await actorModel.setClosure { integer in
                classVarible += 1
                localVarible += 1
                return integer + 1
            }
            await actorModel.setSendableClosure { integer in
//                classVarible += 1 // Main actor-isolated property 'classVarible' can not be mutated from a Sendable closure
//                localVarible += 1 // Mutation of captured var 'count' in concurrently-executing code
                return integer + 1
            }
        }
        
        
    }
}

@available(iOS 13.0.0, *)
actor ActorModel {
    var commonClass = CommonClass()
    var array = [Int]()
    let immuteValue: Int = 3
    var muteValue: Int = 0
    let stylizedName: NSMutableAttributedString = NSMutableAttributedString(string: "wewwe")
    func setMute(_ mute: Int) -> Int {
        muteValue = mute
        return mute + 1
    }
    
    func appendArray(_ value: Int) {
        array.append(value)
    }
    
    func setClosure(closure: (Int) async -> Int) async {
        let _ = await closure(3)
    }
    
    func setSendableClosure(closure: @Sendable (Int) async -> Int) async {
        let _ = await closure(3)
    }
    
    func task() async {
        var counter: Int = 0

        @Sendable func callAPI() {
//            counter += 1   // Mutation of captured var 'counter' in concurrently-executing code
        }
    }
}

class CommonClass {
    var varible: Int = 9
}
