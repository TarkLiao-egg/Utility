//
//  UtilityTests.swift
//  UtilityTests
//
//  Created by Tark on 6/1/22.
//

import XCTest
@testable import Utility

class UtilityTests: XCTestCase {

    override func setUpWithError() throws {
        print("setUpWithError")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        print("tearDownWithError")
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEExample() throws {
        var expectations = [XCTestExpectation]()
        expectations.append(expectation(description: "test expectation"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            print("end wait")
            XCTAssert(true)
            expectations.last?.fulfill()
        }
        print("start wait")
        wait(for: [expectations.last!], timeout: TimeInterval(10))
        
    }
    func testAExample() throws {
        print("test a")
    }
     
    func testNoFullName() throws {
        print("test not full")
    }

    func testPerformanceExample() throws {
        print("test p")
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class ATest: XCTestCase {
    func testEExample() throws {
        print("ATest E")
    }
    func testAExample() throws {
        print("ATest A")
    }
}
