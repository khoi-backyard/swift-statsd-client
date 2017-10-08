//
//  MemoryStorage.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

class MemoryStorage<ItemType>: Storage {
    private let queue = DispatchQueue(label: "StatsD_MemoryStorage", qos: .default, attributes: .concurrent)
    private var internalStorage = [String: ItemType]()

    var count: Int {
        return queue.syncWithReturnedValue {
            internalStorage.count
        }
    }

    func item(forKey key: String) -> ItemType? {
        return queue.syncWithReturnedValue {
            internalStorage[key]
        }
    }

    func set(item: ItemType, forKey: String) {
        queue.async(flags: .barrier) { [unowned self] in
            self.internalStorage[forKey] = item
        }
    }

    func getAllItems() -> [ItemType] {
        return queue.syncWithReturnedValue {
            Array(internalStorage.values)
        }
    }

    func remove(item: ItemType, forKey key: String) {
        queue.syncWithReturnedValue {
            _ = internalStorage.removeValue(forKey: key)
        }
    }

    func removeAll() {
        queue.syncWithReturnedValue {
            internalStorage.removeAll()
        }
    }
}
