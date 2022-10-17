//
//  GCDManager.swift
//  Homework
//
//  Created by 廖力頡 on 2022/2/18.
//

import Foundation
import UIKit
import SwiftUI

class GCDManager {
    
    static func run() {
//        serial()
        operationQueue()
    }
    
    static func test() {
        
    }
    
    
    static func mainSerial() {
        let serialQueue = DispatchQueue(label: "io.some.thread",qos: .userInteractive)
        serialQueue.async {
            for i in 30...39 {
                print(i,"♣",Thread.current)//子线程1
            }
            DispatchQueue.main.async {
                for i in 10...19 {
                   print(i,"♦",Thread.current)//主线程
                }
            }
            DispatchQueue.main.sync {
                for i in 10...19 {
                   print(i,"♦",Thread.current)//主线程
                }
            }
        }
    }
    static func serial() {
        let serialQueue = DispatchQueue(label: "io.some.thread",qos: .userInteractive)
        
        serialQueue.async {
            for i in 30...39 {
                print(i,"♣",Thread.current)//子线程1
            }
        }
        
        serialQueue.sync {
            for i in 20...29 {
               print(i,"♡",Thread.current)//主线程
            }
        }
        for i in 0...9 {
           print(i,"♠2",Thread.current)//主线程
        }
        DispatchQueue.main.async {
            for i in 10...19 {
               print(i,"♦",Thread.current)//主线程
            }
        }
        serialQueue.async {
            for i in 100...110 {
               print(i,"♥",Thread.current)//子线程1
            }
        }
        serialQueue.sync {
            for i in 40...49 {
                print(i,"♢",Thread.current)//主线程
            }
        }
        for i in 0...9 {
           print(i,"♠",Thread.current)//主线程
        }
        //MainAsync 一定在主線程之後
        //從上到下依序，不分async sync
        //async會開子線程
        
        // serial限定了只有一個燒杯一跟過濾網
        // 一個燒杯插一個過濾網，從下往上填滿管子，Main async會擺到最後才填
        // async會流出過濾網，但洞外是同一個燒杯(thread)，只有一個thread
        // queue從下面慢慢流出
    }
    
    static func concurrent() {
        let concurrentQueue = DispatchQueue(label: "io.some.thread",qos: .userInteractive, attributes: .concurrent)
        
        concurrentQueue.async {
            for i in 30...39 {
                print(i,"♣",Thread.current)//子线程1
            }
        }
        
        concurrentQueue.sync {
            for i in 20...29 {
               print(i,"♡",Thread.current)//主线程
            }
        }
        DispatchQueue.main.async {
            for i in 10...19 {
               print(i,"♦",Thread.current)//主线程
            }
        }
        concurrentQueue.async {
            for i in 100...110 {
               print(i,"♥",Thread.current)//子线程2
            }
        }
        for i in 0...9 {
           print(i,"♠ㄉ",Thread.current)//主线程
        }
        concurrentQueue.sync {
            for i in 40...49 {
                print(i,"♢",Thread.current)//主线程
            }
        }
        for i in 0...9 {
           print(i,"♠",Thread.current)//主线程
        }
        //MainAsync 一定在主線程之後
        //sync從上到下依序，main屬於sync
        //async無規則
        //sync跟async之間沒規則
        
        // concurrent 有n個async就有n個燒杯跟n個過濾網, main和sync 是獨立一個燒杯+一個過濾網，main async會擺到最後才填
        // async會流出過濾網，但洞外是同一個燒杯(thread)，但n個燒杯，所以每個thread都不同
        // queue從下面慢慢流出，系統從n+1個燒杯隨機拿
    }
    
    static func serial_sync() {
        let serialQueue = DispatchQueue(label: "io.some.thread",qos: .userInteractive)
        serialQueue.sync {
            for i in 10...20 {
               print(i,Thread.current)//子线程
            }
        }
        serialQueue.sync {
            for i in 100...110 {
               print(i,Thread.current)//子线程
            }
        }
        for i in 0...9 {
           print(i,Thread.current)//主线程
        }
        //從上至下依序進行，全在主線程
    }
    
    static func serial_async() {
        let serialQueue = DispatchQueue(label: "io.some.thread",qos: .userInteractive)
        serialQueue.async {
            for i in 10...20 {
               print(i,Thread.current)//子线程
            }
        }
        serialQueue.async {
            for i in 100...110 {
               print(i,Thread.current)//子线程
            }
        }
        for i in 0...9 {
           print(i,Thread.current)//主线程
        }
        //主子線不規則，子線依序
    }
    
    static func concurrent_async() {
        let concurrentQueue = DispatchQueue(label: "io.some.thread",qos: .userInteractive, attributes: .concurrent)
        concurrentQueue.async {
            for i in 10...20 {
               print(i,Thread.current)//子线程
            }
        }
        concurrentQueue.async {
            for i in 100...110 {
               print(i,Thread.current)//子线程
            }
        }
        for i in 0...9 {
           print(i,Thread.current)//主线程
        }
        //主子線不規則
    }
    
    static func concurrent_sync() {
        let concurrentQueue = DispatchQueue(label: "io.some.thread", attributes: .concurrent)
        concurrentQueue.sync {
            for i in 10...20 {
               print(i,Thread.current)//主线程
            }
        }
        concurrentQueue.sync {
            for i in 100...110 {
               print(i,Thread.current)//主线程
            }
        }
        for i in 0...9 {
           print(i,Thread.current)//主线程
        }
        //從上至下依序進行，全在主線程
    }
    
    // MARK: 同步任務應用
    class BlurImageOperation: Operation {
        var inputImage: UIImage?
        var outputImage: UIImage?
            
        override func main() {
            sleep(3)
            print("end operation \(Thread.current)")
        }
    }
    static func operationQueue() {
        let queue = OperationQueue()
        let op = BlurImageOperation()
        let op2 = BlurImageOperation()
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        op.completionBlock = {
            print("op1完成")
            group.leave()
        }
        op2.completionBlock = {
            print("op2完成")
            group.leave()
        }
        queue.addOperation(op)
        queue.addOperation(op2)
        queue.addOperation {
            print("option1 \(Thread.current)")
        }
        queue.waitUntilAllOperationsAreFinished()
        print("end")
        
        group.notify(queue: DispatchQueue.main) {
            print("group 任务执行结束")
            print(Thread.current)
        }
    }
    
    static func handleOperation() {
        let blockOperation = BlockOperation()
        for i in 1...10 {
            blockOperation.addExecutionBlock {
                sleep(2)
                print("\(i) in blockOperation: \(Thread.current)")
            }
        }
        blockOperation.completionBlock = {
            print("All block operation task finished: \(Thread.current)")
        }
        blockOperation.start()
        // Block裡面並行
    }
    
    static func handleOperationQueue() {
        let operationQueue = OperationQueue()
        // DONE later: Set maximum to 2
//        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.addOperation {print("tark1")}
        operationQueue.addOperation {print("tark2")}
        operationQueue.addOperation {print("tark3")}
        operationQueue.addOperation {print("tark4")}
        operationQueue.addOperation {print("tark5")}
//        operationQueue.cancelAllOperations()
        operationQueue.waitUntilAllOperationsAreFinished()
    }
    
    static func handleOperationQueueDependency() {
        let operationQueue = OperationQueue()
        let bO1 = BlockOperation {
            print("test1")
        }
        let bO2 = BlockOperation {
            print("test2")
        }
        let bO3 = BlockOperation {
            print("test3")
        }
        let bO4 = BlockOperation {
            print("test4")
        }
        let bO5 = BlockOperation {
            print("test5")
        }
        bO2.addDependency(bO1)// bO2等bO1執行完 才執行
        
        operationQueue.addOperation(bO2)
        operationQueue.addOperation(bO1)
        operationQueue.addOperation(bO3)
        operationQueue.addOperation(bO4)
        operationQueue.addOperation(bO5)
        operationQueue.cancelAllOperations()
        bO4.cancel()
        bO1.cancel() // 2雖然有相依性，但如果被取消則不會受限
//        operationQueue.cancelAllOperations()
//        operationQueue.progress.pause()
//        operationQueue.progress.resume()
//        阻塞在这里
        operationQueue.waitUntilAllOperationsAreFinished()
    }
    
    // MARK: 異步應用
    static func dispatchGroup() {
        // DispatchGroup 異步任務同步結果
        let group = DispatchGroup()
        for i in 0...1 {
            DispatchQueue.global().async {
                group.enter()
                getData(i) {
                    group.leave()
                }
            }
        }
        //queue参数表示以下任务添加到的队列
        group.notify(queue: DispatchQueue.global()) {
            print("group 任务执行结束")
            print(Thread.current)
        }
        func getData(_ i: Int, completion: (()-> Void)?) {
            sleep(arc4random()%3)//休眠时间随机
            print(i)
            completion?()
        }
    }
    
    static func semaphore() {
//        如果semaphore的值不为0，上面函数返回success，同时会将semaphore的值减1；
//        如果是0，则线程一直等待（函数不返回，下面的代码不会执行），直到timeout
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            sleep(arc4random()%5)//休眠时间随机
            print("completed")
            semaphore.signal()
        }
        switch semaphore.wait(timeout: DispatchTime.now()+10) {//信号量为0，调用wait后阻塞线程
        case .success:
            print("success")
        case .timedOut:
            print("timeout")
        }
        print("over")
    }
}
