//
//  DiskStorage.swift
//  StatsdClient-iOS
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

final class DiskStorage<Item: Codable>: Storage {

    private let handler: PersistentHandler
    private let queue = DispatchQueue(label: "StatsD_DiskStorage", qos: .default, attributes: .concurrent)

    var count: Int {
        return queue.syncWithReturnedValue { self.handler.fileCount }
    }

    init(handler: PersistentHandler) {
        self.handler = handler
    }

    init?(config: DiskConfigurable) {

        guard let handler = try? DiskPersistentHandler(config: config) else {
            return nil
        }

        self.handler = handler
    }

    func item(forKey key: String) -> Item? {
        return queue.syncWithReturnedValue {
            try? handler.get(key: key, type: Item.self)
        }
    }

    func set(item: Item, forKey key: String) {
        queue.async(flags: .barrier) { [unowned self] in
            try? self.handler.write(item, key: key, attribute: nil)
        }
    }

    func getAll() -> [Item] {
        return queue.syncWithReturnedValue {
            guard let items = try? handler.getAll(type: Item.self) else {
                return []
            }
            return items
        }
    }

    func remove(key: String) throws {
        try queue.sync {
            try handler.deleteFile(key)
        }
    }

    func removeAll() throws {
        try queue.sync {
            try handler.deleteAllFile()
        }
    }
}
