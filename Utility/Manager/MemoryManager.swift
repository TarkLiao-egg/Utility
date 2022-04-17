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
        mapOrFlatMapOrCompactMap()
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
