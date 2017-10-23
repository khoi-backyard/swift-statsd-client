//
//  MemoryStorageTests.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

class MemoryStorageTests: XCTestCase {

    let memoryStorage = MemoryStorage<String>()

    override func setUp() {
        super.setUp()
        memoryStorage.removeAll()
    }

    func testInsertion() {
        XCTAssertEqual(memoryStorage.count, 0, "Storage count should start with 0")
        memoryStorage.set(item: "someItem", forKey: "key1")
        XCTAssertEqual(memoryStorage.count, 1, "Storage count should equal to number of items")
        XCTAssertEqual(memoryStorage.item(forKey: "key1"), "someItem")
    }

    func testRetrieveItem() {
        memoryStorage.set(item: "item1", forKey: "key1")
        memoryStorage.set(item: "item2", forKey: "key2")
        XCTAssertEqual(memoryStorage.count, 2, "Storage count should equal to number of items")
        XCTAssertEqual(memoryStorage.item(forKey: "key1"), "item1")
        XCTAssertEqual(memoryStorage.item(forKey: "key2"), "item2")
        XCTAssertEqual(Set(memoryStorage.getAll()), Set(["item1", "item2"]))
    }

    func testRemoveItem() {
        memoryStorage.set(item: "item1", forKey: "key1")
        memoryStorage.set(item: "item2", forKey: "key2")
        memoryStorage.set(item: "item3", forKey: "key3")
        XCTAssertEqual(memoryStorage.count, 3, "Storage count should equal to number of items")

        memoryStorage.remove(key: "key1")
        XCTAssertEqual(memoryStorage.count, 2)
        XCTAssertNil(memoryStorage.item(forKey: "key1"))
        XCTAssertEqual(memoryStorage.item(forKey: "key2"), "item2", "Other items must still be intact")
        XCTAssertEqual(memoryStorage.item(forKey: "key3"), "item3", "Other items must still be intact")

        memoryStorage.removeAll()
        XCTAssertEqual(memoryStorage.count, 0)
        XCTAssertNil(memoryStorage.item(forKey: "key2"))
        XCTAssertNil(memoryStorage.item(forKey: "key3"))
    }

    func testStorageForMetricType() {
        let metricStorage = MemoryStorage<Metric>()
        let countingMetric = Counting(name: "counter", value: 1, sample: 0.3)
        metricStorage.set(item: countingMetric, forKey: "count1")

        XCTAssertEqual(metricStorage.count, 1)
        if let storedMetric = metricStorage.item(forKey: "count1") {
            XCTAssertEqual(storedMetric.name, countingMetric.name)
            XCTAssertEqual(storedMetric.value, countingMetric.value)
            XCTAssertEqual(storedMetric.sample, countingMetric.sample)
            XCTAssertEqual(storedMetric.metricData, countingMetric.metricData)
        } else {
            XCTFail("Can't get the item out of the storage")
        }
    }
}
