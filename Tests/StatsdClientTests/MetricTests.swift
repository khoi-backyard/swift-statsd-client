//
//  MetricTests.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

class MetricTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCounting() {
        XCTAssertEqual(Counting(name: "gorets", value: 1).metricData, "gorets:1|c")
        XCTAssertEqual(Counting(name: "gorets", value: -5).metricData, "gorets:-5|c")
        XCTAssertEqual(Counting(name: "gorets", value: 0).metricData, "gorets:0|c")

        XCTAssertEqual(Counting(name: "gorets", value: 1, sample: 0.1).metricData, "gorets:1|c|@0.1")
        XCTAssertEqual(Counting(name: "gorets", value: -5, sample: 0.2).metricData, "gorets:-5|c|@0.2")
        XCTAssertEqual(Counting(name: "gorets", value: 0, sample: 1.0).metricData, "gorets:0|c|@1")
    }

    func testSet() {
        XCTAssertEqual(Sets(name: "uniques", value: "765").metricData, "uniques:765|s")
        XCTAssertEqual(Sets(name: "abc", value: "foo").metricData, "abc:foo|s")
        XCTAssertEqual(Sets(name: "def", value: "bar").metricData, "def:bar|s")
    }
    
    static var allTests = [
        ("testCounting", testCounting),
        ("testSet", testSet),
    ]
    
}
