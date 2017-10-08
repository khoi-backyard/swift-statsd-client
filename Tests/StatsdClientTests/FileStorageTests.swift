//
//  FileyStorageTests.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

class FileStorageTests: XCTestCase {

    let fileStorage = FileStorage<String>()

    override func setUp() {
        super.setUp()
        fileStorage.removeAll()
    }

    func testInsertion() {
        XCTAssertEqual(fileStorage.count, 0, "Storage count should start with 0")
        fileStorage.set(item: "someItem", forKey: "key1")
        XCTAssertEqual(fileStorage.count, 1, "Storage count should equal to number of items")
        XCTAssertEqual(fileStorage.item(forKey: "key1"), "someItem")
    }

    func testRetrieveItem() {
        fileStorage.set(item: "item1", forKey: "key1")
        fileStorage.set(item: "item2", forKey: "key2")
        XCTAssertEqual(fileStorage.count, 2, "Storage count should equal to number of items")
        XCTAssertEqual(fileStorage.item(forKey: "key1"), "item1")
        XCTAssertEqual(fileStorage.item(forKey: "key2"), "item2")
        XCTAssertEqual(Set(fileStorage.getAllItems()), Set(["item1", "item2"]))
    }

    func testRemoveItem() {
        fileStorage.set(item: "item1", forKey: "key1")
        fileStorage.set(item: "item2", forKey: "key2")
        fileStorage.set(item: "item3", forKey: "key3")
        XCTAssertEqual(fileStorage.count, 3, "Storage count should equal to number of items")

        fileStorage.remove(key: "key1")
        XCTAssertEqual(fileStorage.count, 2)
        XCTAssertNil(fileStorage.item(forKey: "key1"))
        XCTAssertEqual(fileStorage.item(forKey: "key2"), "item2", "Other items must still be intact")
        XCTAssertEqual(fileStorage.item(forKey: "key3"), "item3", "Other items must still be intact")

        fileStorage.removeAll()
        XCTAssertEqual(fileStorage.count, 0)
        XCTAssertNil(fileStorage.item(forKey: "key2"))
        XCTAssertNil(fileStorage.item(forKey: "key3"))
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

