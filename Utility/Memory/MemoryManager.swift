//
//  MemoryManager.swift
//  Homework
//
//  Created by 廖力頡 on 2022/2/19.
//

import Foundation
import UIKit

class MemoryManager {
    static let shared = MemoryManager()
    var testInt: Int = 3
    let testLet: Int = 3
    static func run() {
        test()
    }
    
    static func test() {
        var callsd = ClassInfo()
        var sdwe: String = "1234567890"
        var array = [1,2,3,4,5]
        withUnsafeMutablePointer(to: &callsd) { pointer in
            print(pointer)
        }
        withUnsafeMutablePointer(to: &sdwe) { pointer in
            print(pointer)
        }
        withUnsafeMutablePointer(to: &array) { pointer in
            print(pointer)
        }
        
        print(array)
        array.withUnsafeMutableBufferPointer { pointer in
            pointer.dropFirst()
            pointer.baseAddress?.pointee = 4
            pointer[3] = 4
        }
        print(array)
        array.withUnsafeBufferPointer { pointer in
            pointer.dropFirst()
        }
        print(array)
        withUnsafeMutableBytes(of: &callsd) { pointer in
            print(pointer.baseAddress?.advanced(by: 1))
            print("tark2")
        }
        print("tark1")
        print(MemoryLayout.size(ofValue: array))
        withUnsafeMutablePointer(to: &sdwe) { pointer in
            print("\nstruct")
            print(pointer)
            print(pointer.pointee)
        }
        withUnsafeMutableBytes(of: &sdwe) { pointer in
            print("\nstruct2")
            print(pointer)
            pointer.storeBytes(of: 50, toByteOffset: 2, as: UInt8.self)
        }
        withUnsafePointer(to: &sdwe) { pointer in
            print("\nstruct")
            print(pointer)
            print(pointer.pointee)
//            pointer.pointee = 5
        }
        print(sdwe)
        withUnsafePointer(to: &callsd) { pointer in
            print("\nclass")
            print(pointer)
            print(pointer.pointee)
        }
        
        array.withUnsafeBytes { point in
            print("\narray")
            print(point.baseAddress)
            print(point.startIndex)
            print(point)
        }
        let pointer = UnsafeMutablePointer<Int>.allocate(capacity: 5)
        let bufferPointer = UnsafeMutableBufferPointer<Int>.init(start: pointer, count: 5)
        
        var int: Int = 123
        let intPointer = UnsafeMutablePointer(&int)
        let rawPointer = UnsafeMutableRawPointer(intPointer)
        intPointer.pointee = 3
        rawPointer.storeBytes(of: 3, as: Int.self)
        
        array.withUnsafeMutableBufferPointer { pointer in
            print(pointer.baseAddress?.advanced(by: 1).pointee = 3)
            print(pointer.baseAddress)
            let _ = pointer.initialize(from: [5,4,3,2,1])
            pointer[0] = 2
            
        }
        array.withUnsafeMutableBytes { pointer in
            for poi in pointer {

                print(poi)
            }
        }
        array.withUnsafeBufferPointer { pointer in
            print(pointer)
            print(pointer.baseAddress)
            print(pointer.count)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print(array)
        }
    }
    
    func safeRead(ptr: Int) {
//        let result = mach_vm_read_overwrite(mach_task_self_, ptr64, mach_vm_size_t(bufferCount), target64, &outsize)
    }
    
    static func arrayNature() {
        var array = [0,1,2,3,4]
        print(MemoryLayout.size(ofValue: array)) // 8
        array.append(5)
        print(MemoryLayout.size(ofValue: array)) // 8
        array.append(contentsOf: [5,6,7,8,9,9])
        print(MemoryLayout.size(ofValue: array)) // 8
    }
    
    static func mapOrFlatMapOrCompactMap() {
//        print(RunLoop.current)
//        RunLoop.current.
        let arrays = [[1,2,3,nil], [nil, nil,5,4,6]]
        let map = arrays.map { item -> [Int?] in
            return item
        }
        let flatmap = arrays.flatMap { $0}
        let compactmap = flatmap.compactMap { items -> Int? in
            return items
        }
        print(map)
        print(Array(map.joined()))
        print(flatmap)
        print(compactmap)
        
    }

    
    static func conflict() {
        var age = 10

        func increment(_ num: inout Int) { // step1
            num += age // step2
        }
        increment(&age)
    }
    
    static func objectInfo() {
        var age = 10
        print(ObjectIdentifier(RunLoop.current))
        print(MemoryLayout<MemoryManager>.size)
        print(class_getInstanceSize(MemoryManager.self))
        var pr1 = withUnsafeMutablePointer(to: &age) {//記憶體位置
            $0
           print($0)
        }
        var pr2 = withUnsafePointer(to: &age) {//記憶體位置
            $0
           print($0)
        }
//        var age = 10
        var ptr = malloc(16)
        ptr?.storeBytes(of: 10, as: Int.self)
        ptr?.storeBytes(of: 12, toByteOffset: 8, as: Int.self)
        print(ptr?.load(as: Int.self))
        print(ptr?.load(fromByteOffset: 8, as: Int.self) ?? 0)
        
//        pr1.
//        pr1.pointee = 22
//        pr2.pointee = 22
//        withUnsafePointer(to: &shared.testLet) {//記憶體位置
//           print($0)
//        }
//        withUnsafeMutablePointer(to: &shared.testLet) {//記憶體位置
//           print($0)
//        }
        

    }
    
    static func mixStruct_Class() {
        let structInfo = StructInfo()
        print(structInfo)
        structInfo.cla.cNum1 = 5
        print(structInfo)
    }
}

struct StructInfo {
    var num1: Int = 0
    let num2: Int = 2
    let cla: ClassInfo = ClassInfo()
    let stru: StructInfo2 = StructInfo2()
}

struct StructInfo2 {
    var num3: Int = 0
    let num4: String = "2"
}

class ClassInfo {
    var cNum1: Int = 3
    var cNum2: Int = 4
}
