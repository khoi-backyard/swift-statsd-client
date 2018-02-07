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

    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()

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

        let counting = Counting(name: "gorets", value: 1, sample: 0.1)
        if let jsonData = try? jsonEncoder.encode(counting),
            let decodedObject = try? jsonDecoder.decode(Counting.self, from: jsonData) {
            XCTAssertEqual(decodedObject.name, counting.name)
            XCTAssertEqual(decodedObject.value, counting.value)
            XCTAssertEqual(decodedObject.sample, counting.sample)
            XCTAssertEqual(decodedObject.metricData, counting.metricData)
        } else {
            XCTFail("Failed to encode \(counting)")
        }
    }

    func testSet() {
        XCTAssertEqual(Sets(name: "uniques", value: "765").metricData, "uniques:765|s")
        XCTAssertEqual(Sets(name: "abc", value: "foo").metricData, "abc:foo|s")
        XCTAssertEqual(Sets(name: "def", value: "bar").metricData, "def:bar|s")

        let set = Sets(name: "uniques", value: "765")
        if let jsonData = try? jsonEncoder.encode(set),
            let decodedObject = try? jsonDecoder.decode(Sets.self, from: jsonData) {
            XCTAssertEqual(decodedObject.name, set.name)
            XCTAssertEqual(decodedObject.value, set.value)
            XCTAssertNil(set.sample)
            XCTAssertNil(decodedObject.sample)
            XCTAssertEqual(decodedObject.metricData, set.metricData)
        } else {
            XCTFail("Failed to encode \(set)")
        }
    }

    func testTiming() {
        XCTAssertEqual(Timing(name: "api.foo.bar", value: 101).metricData, "api.foo.bar:101|ms")
        XCTAssertEqual(Timing(name: "api.foo.bar", value: -5).metricData, "api.foo.bar:-5|ms")
        XCTAssertEqual(Timing(name: "api.foo.bar", value: 0).metricData, "api.foo.bar:0|ms")

        XCTAssertEqual(Timing(name: "api.foo.bar", value: 199, sample: 0.1).metricData, "api.foo.bar:199|ms|@0.1")
        XCTAssertEqual(Timing(name: "api.foo.bar", value: 403, sample: 0.2).metricData, "api.foo.bar:403|ms|@0.2")
        XCTAssertEqual(Timing(name: "api.foo.bar", value: 929, sample: 1.0).metricData, "api.foo.bar:929|ms|@1")

        let timing = Timing(name: "api.foo.bar", value: 199, sample: 0.1)
        if let jsonData = try? jsonEncoder.encode(timing),
            let decodedObject = try? jsonDecoder.decode(Timing.self, from: jsonData) {
            XCTAssertEqual(decodedObject.name, timing.name)
            XCTAssertEqual(decodedObject.value, timing.value)
            XCTAssertEqual(decodedObject.sample, timing.sample)
            XCTAssertEqual(decodedObject.metricData, timing.metricData)
        } else {
            XCTFail("Failed to encode \(timing)")
        }
    }

    func testGauge() {
        XCTAssertEqual(Gauge(name: "gaugor", value: 10).metricData, "gaugor:10|g")
        XCTAssertEqual(Gauge(name: "gaugor", value: 1).metricData, "gaugor:1|g")
        XCTAssertEqual(Gauge(name: "gaugor", value: 0).metricData, "gaugor:0|g")

        XCTAssertEqual(Gauge(name: "gaugor", delta: 0).metricData, "gaugor:+0|g")
        XCTAssertEqual(Gauge(name: "gaugor", delta: 123).metricData, "gaugor:+123|g")
        XCTAssertEqual(Gauge(name: "gaugor", delta: -234).metricData, "gaugor:-234|g")

        let gaugor = Gauge(name: "gaugor", delta: -234)
        if let jsonData = try? jsonEncoder.encode(gaugor),
            let decodedObject = try? jsonDecoder.decode(Gauge.self, from: jsonData) {
            XCTAssertEqual(decodedObject.name, gaugor.name)
            XCTAssertEqual(decodedObject.value, gaugor.value)
            XCTAssertNil(gaugor.sample)
            XCTAssertNil(decodedObject.sample)
            XCTAssertEqual(decodedObject.metricData, gaugor.metricData)
        } else {
            XCTFail("Failed to encode \(gaugor)")
        }
    }

    static var allTests = [
        ("testCounting", testCounting),
        ("testSet", testSet),
        ("testTiming", testTiming),
        ("testGauge", testGauge),
    ]

}
