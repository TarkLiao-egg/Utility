import UIKit
// MARK: for XCode above` 13.2
class ConcurrencyController: UIViewController {

    override func viewDidLoad() {

        let concurrentQueue = DispatchQueue(label: "io.some.thread",qos: .userInteractive, attributes: .concurrent)
//        concurrentQueue.async {
//            async let data = asyncAction() // equal async let data = await asyncAction()
//            print("async progress") // not wait data result
//            print(await data + " async let")
//        }
//        if #available(iOS 15.0, *) {
            //        doTask()
            //        doCompetionAction()
            //        doCompletionToConcurrencyAction()
        if #available(iOS 13.0, *) {
            doCompletionThrowsToConcurrencyAction()
        } else {
            // Fallback on earlier versions
        }
//        } else {
//            // Fallback on earlier versions
//        }
    }
}
@available(iOS 13.0, *)
extension ConcurrencyController {
    func doOnMainThread() async {
        await MainActor.run {
          // 更新 UI
        }
        
        Task { @MainActor in
          // 這裡的函數將在 UI 線程上運行
        }
    }
    @MainActor func iWillRunInMainThread() async {
      // 這個函數將在 UI 線程中運行
    }

}

@available(iOS 13.0, *)
extension ConcurrencyController {
    func doTask() {
        Task {
            async let data = asyncAction() // equal async let data = await asyncAction()
            print("async progress") // not wait data result
            print(await data + " async let")
        }
        
        Task {
            let data = await asyncAction()
            print("normal progress") // wait data result
            print(data + " normal")
        }
    }
    
    func asyncAction() async -> String {
        await Task.sleep(2.toSecond())
        return "async data"
    }
}

@available(iOS 13.0, *)
extension ConcurrencyController {
    func doCompletionToConcurrencyAction() {
        Task {
            let data = await completionToConcurrency()
            print(data)
        }
    }
    
    func doCompletionThrowsToConcurrencyAction() {
        Task {
            let data = try await comletionThrowsToConcurrency()
            print(data)
        }
    }
    
    func completionToConcurrency() async -> String {
        typealias CompletionContinuation = CheckedContinuation<String, Never>
        return await withCheckedContinuation { [weak self] (continuation: CompletionContinuation) in
            self?.getCompletionResult { str in
                continuation.resume(returning: str)
            }
        }
    }
    
    func comletionThrowsToConcurrency() async throws -> String {
        typealias CompletionThrowsContinuation = CheckedContinuation<String, Error>
        return try await withCheckedThrowingContinuation { [weak self] (continuation: CompletionThrowsContinuation) in
            self?.getCompetionThrowsResult(completion: { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let err):
                    continuation.resume(throwing: err)
                }
            })
        }
    }
}

@available(iOS 13.0, *)
extension ConcurrencyController {
    enum TestError: Error {
        case unknown
    }
    
    func doCompetionAction() {
        getCompletionResult { result in
            print(result)
        }
    }
    
    func getCompletionResult(completion: ((String) -> Void)?) {
        print("start competion")
        Task {
            sleep(2)
            completion?("completion result")
        }
    }
    
    func getCompetionThrowsResult(completion: ((Result<String, TestError>) -> Void)?) {
        print("start competionThrows")
        Task {
            sleep(2)
            completion?(.success("completionThrows result"))
//            completion?(.failure(.unknown))
        }
    }
}

extension Int {
    func toSecond() -> UInt64 {
        return UInt64(self) * 1000000000
    }
}
