//
//  StatsDTests.swift
//  StatsdClient-iOS Tests
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

class StatsDTests: XCTestCase {

    var spyScheme: SpyScheme!
    var storage: MemoryStorage<Metric>!
    var client: StatsD!
    var transport: MockTransport!

    override func setUp() {
        super.setUp()

        spyScheme = SpyScheme()
        let flush = Flush(schemes: [spyScheme])
        transport = MockTransport()
        storage = MemoryStorage<Metric>()
        client = StatsD(transport: transport, storage: storage, flush: flush)
    }

    override func tearDown() {
        super.tearDown()

        storage.removeAll()
    }

    func testClientShouldStoreCounting() {

        let key = "increment"
        client.increment(key)

        guard let metric = storage.item(forKey: key) else {
            XCTFail("Metric is nil")
            return
        }
        XCTAssertNotNil(metric as? Counting, "Metric should store as Counting for increment()")
    }

    func testClientShouldStoreSets() {

        let key = "set"
        let value = "1"
        client.set(key, value: value)

        guard let metric = storage.item(forKey: key) else {
            XCTFail("Metric is nil")
            return
        }
        XCTAssertNotNil(metric as? Sets, "Metric should store as Sets for set()")
        XCTAssertEqual(metric.value, value, "Metric should same value")
    }

    func testClientShouldStoreTiming() {

        let key = "timing"
        let value = 100
        client.timing(key, value: value)

        guard let metric = storage.item(forKey: key) else {
            XCTFail("Metric is nil")
            return
        }
        XCTAssertNotNil(metric as? Timing, "Metric should store as Timing for timing()")
        XCTAssertEqual(metric.value, "\(value)", "Metric should same value")
    }

    func testClientShouldStoreGaugeDelta() {

        let key = "gauge"
        let value = 100
        client.gauge(key, delta: value)

        guard let metric = storage.item(forKey: key) else {
            XCTFail("Metric is nil")
            return
        }
        XCTAssertNotNil(metric as? Gauge, "Metric should store as Gauge for gauge()")
        XCTAssertEqual(metric.value, "+\(value)", "Metric should same value")
    }

    func testClientShouldStoreGauge() {

        let key = "gauge"
        let value: UInt = 100
        client.gauge(key, value: value)

        guard let metric = storage.item(forKey: key) else {
            XCTFail("Metric is nil")
            return
        }
        XCTAssertNotNil(metric as? Gauge, "Metric should store as Gauge for gauge()")
        XCTAssertEqual(metric.value, "\(value)", "Metric should same value")
    }

    func testClientWithEmptyStorage() {

        spyScheme.excess()
        XCTAssertFalse(transport.isCallWritten, "Shouldn't call transport if Storage is Empty")
    }

    func testClientShouldTransportBatchWhenSchemeExcess() {
        let keyLogin = "login"
        let keySignUp = "signup"
        let expect = "login:1|c\nsignup:1|c"

        client.increment(keyLogin)
        client.increment(keySignUp)
        spyScheme.excess()

        XCTAssertTrue(transport.isCallWritten, "Should call transport")
        XCTAssertEqual(transport.writeData, expect, "Correct Batch format")
    }

    func testClientShouldRemoveAllStorageAfterFlushed() {
        let keyLogin = "login"

        client.increment(keyLogin)
        XCTAssertEqual(storage.count, 1, "Storage count should equal 1")
        spyScheme.excess()

        XCTAssertTrue(transport.isCallWritten, "Should call transport")
        XCTAssertEqual(storage.count, 0, "After flushing, Storage should be flushed too")
    }

    func testClientShouldNotRemoveStorageIfTransportError() {
        let keyLogin = "login"

        client.increment(keyLogin)
        XCTAssertEqual(storage.count, 1, "Storage count should equal 1")
        transport.fakeError = NSError(domain: "Internet broken", code: 1, userInfo: nil)
        spyScheme.excess()

        XCTAssertTrue(transport.isCallWritten, "Should call transport")
        XCTAssertEqual(storage.count, 1, "If transport gets error, Client should not clean Storage")
    }
}
