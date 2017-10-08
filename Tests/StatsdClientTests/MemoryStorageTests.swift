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

}
