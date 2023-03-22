import UIKit

@available(iOS 13.0, *)
class TaskController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        taskThread()
        
    }
    
    func taskThread() {
        Task(priority: .utility) {
            print("Task start")
            for _ in 0...1000000 {
                
            }
            await check()
            print("Task end")
        }
        
        Task(priority: .userInitiated) {
            print("Task userInitiated")
            await check()
            print("Task userInitiated end")
        }
        
        Task(priority: .utility) {
            print("Task utility")
            await check()
            print("Task utility end")
        }
        DispatchQueue.global().async { [unowned self] in
            Task(priority: .background) {
                print("Task background")
                await check()
                print("Task background end")
            }
        }
        
        print("outside")
    }
    
    func task() {
        Task.detached(priority: .userInitiated) { [weak self] in
            print("tark1")
//            await self?.check()
            try await Task.sleep(nanoseconds: 3_000_000_000)
//            Thread.sleep(forTimeInterval: 1)
//            for i in 1...10 {
//                await actorModel.appendArray(i)
//                await print(actorModel.array.sorted())
//            }
            print("tark5")
        }
        Task.detached(priority: .background) {
            print("tark2")
//            for i in 21...30 {
//                await actorModel.appendArray(i)
//                await print(actorModel.array.sorted())
//            }
        }
        
        Task(priority: .background) {
            print("tark3")
//            for i in 11...20 {
//                await actorModel.appendArray(i)
//                await print(actorModel.array.sorted())
//            }
        }
        
        Task(priority: .utility) {
            print("tark4")
//            for i in 11...20 {
//                await actorModel.appendArray(i)
//                await print(actorModel.array.sorted())
//            }
        }
    }
    
    func check() async {
        Thread.sleep(forTimeInterval: Double.random(in: 0...1))
    }
}
