//
//  MemoryStorage.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

class MemoryStorage<Item>: Storage {
    private let queue = DispatchQueue(label: "StatsD_MemoryStorage", qos: .default, attributes: .concurrent)
    private var internalStorage = [String: Item]()

    var count: Int {
        return queue.syncWithReturnedValue {
            internalStorage.count
        }
    }

    func item(forKey key: String) -> Item? {
        return queue.syncWithReturnedValue {
            internalStorage[key]
        }
    }

    func set(item: Item, forKey: String) {
        queue.async(flags: .barrier) { [unowned self] in
            self.internalStorage[forKey] = item
        }
    }

    func getAll() -> [Item] {
        return queue.syncWithReturnedValue {
            Array(internalStorage.values)
        }
    }

    func remove(key: String) {
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
