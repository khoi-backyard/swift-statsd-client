//
//  DiskStorageTests.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

class DiskStorageTests: XCTestCase {

    var disk: DiskStorage<StubMetric, String>!

    override func setUp() {
        super.setUp()
        disk = DiskStorage<StubMetric, String>(config: DiskConfiguration.default)
    }

    override func tearDown() {
        super.tearDown()

        try? disk.removeAll()
    }

    func testCreateDiskStorageWithDefaultConfiguration() {
        let disk = DiskStorage<StubMetric, String>(config: DiskConfiguration.default)

        XCTAssertNotNil(disk, "Can't create DiskStorage with default configuration")
        guard let _disk = disk else {
            XCTFail("Disk is nill")
            return
        }
        XCTAssertEqual(_disk.count, 0, "Disk count should be 0")
    }

    func testSaveIndividualItem() {

        let metric = StubMetric()
        disk.set(item: metric, forKey: metric.name)

        let wrongItem = disk.item(forKey: "abc")
        let rightItem = disk.item(forKey: metric.name)

        XCTAssertEqual(disk.count, 1, "Disk Count should be 1")
        XCTAssertNil(wrongItem, "Item with wrong key should be nil when received from Disk")
        XCTAssertNotNil(rightItem, "Item with proper key should be received successfully")
        guard let _rightItem = rightItem else {
            XCTFail("rightItem is nill")
            return
        }
        XCTAssertEqual(_rightItem, metric, "Item before and after is same data")
    }

    func testRemoveIndividualItem() {

        let metric = StubMetric()
        disk.set(item: metric, forKey: metric.name)

        try? disk.remove(key: "wrongKey")
        XCTAssertEqual(disk.count, 1, "Disk count should be 1 because there is no deletion")

        try? disk.remove(key: metric.name)
        XCTAssertEqual(disk.count, 0, "Disk count should be 0 after removed")
    }

    // Naming test-func is the hardest task
    func testRemoveIndividualItemButStillHaveItem() {

        let metric = StubMetric()
        let anotherMetric = StubMetric(name: "Aloha")

        disk.set(item: metric, forKey: metric.name)
        disk.set(item: anotherMetric, forKey: anotherMetric.name)

        try? disk.remove(key: "wrongKey")
        XCTAssertEqual(disk.count, 2, "Disk count should be 2 because there is no deletion")

        try? disk.remove(key: metric.name)
        XCTAssertEqual(disk.count, 1, "Disk count should be 1 after removed 1")
    }

    func testAddTwoItemWithSameKey() {

        let firstMetric = StubMetric()
        let secondMetric = StubMetric()

        disk.set(item: firstMetric, forKey: firstMetric.name)
        disk.set(item: secondMetric, forKey: secondMetric.name)

        XCTAssertEqual(disk.count, 1, "Disk Count should be 1 because two items have same key")
    }

    func testAddTwoItemWithSameKeyAndDifferentItem() {

        let firstMetric = StubMetric()
        let secondMetric = StubMetric()
        let thirdMetric = StubMetric(name: "Aloha")

        disk.set(item: firstMetric, forKey: firstMetric.name)
        disk.set(item: secondMetric, forKey: secondMetric.name)
        disk.set(item: thirdMetric, forKey: thirdMetric.name)

        XCTAssertEqual(disk.count, 2, "Disk Count should be 2")
    }

    func testRemoveAll() {

        let firstMetric = StubMetric()
        let secondMetric = StubMetric(name: "Aloha")

        disk.set(item: firstMetric, forKey: firstMetric.name)
        disk.set(item: secondMetric, forKey: secondMetric.name)

        try? disk.removeAll()

        let item_1 = disk.item(forKey: firstMetric.name)
        let item_2 = disk.item(forKey: secondMetric.name)

        XCTAssertEqual(disk.count, 0, "Disk Count should be 2")
        XCTAssertNil(item_1, "Shouldn't received because Disk was removed all")
        XCTAssertNil(item_2, "Shouldn't received because Disk was removed all")
    }

    func testGetAllItems() {

        let firstMetric = StubMetric()
        let secondMetric = StubMetric()
        let thirdMetric = StubMetric(name: "Aloha")

        disk.set(item: firstMetric, forKey: firstMetric.name)
        disk.set(item: secondMetric, forKey: secondMetric.name)
        disk.set(item: thirdMetric, forKey: thirdMetric.name)

        let items = disk.getAllItems()

        XCTAssertEqual(disk.count, 2, "Disk Count should be 2")
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0], thirdMetric, "Should same data with metric 3")
        XCTAssertEqual(items[1], firstMetric, "Should same data with metric 2")
    }
}
