//
//  MockStorage.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/15/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation
@testable import StatsdClient

class MockStorage<ItemType>: MemoryStorage<ItemType> {

    private var internalStorage = [String: ItemType]()

    override var count: Int {
        return internalStorage.count
    }

    override func item(forKey key: String) -> ItemType? {
        return internalStorage[key]
    }

    override func set(item: ItemType, forKey: String) {
        internalStorage[forKey] = item
    }

    override func getAllItems() -> [ItemType] {
        return Array(internalStorage.values)
    }

    override func remove(key: String) {
        _ = internalStorage.removeValue(forKey: key)
    }

    override func removeAll() {
        internalStorage.removeAll()
    }
}
