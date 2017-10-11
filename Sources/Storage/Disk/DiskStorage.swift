//
//  DiskStorage.swift
//  StatsdClient-iOS
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

final class DiskStorage<ItemType: Codable>: Storage {

    typealias Key = String

    // MARK: - Variable
    private let handler: PersistentHandler
    private let queue = DispatchQueue(label: "StatsD_DiskStorage", qos: .default, attributes: .concurrent)

    var count: Int {
        return queue.syncWithReturnedValue { self.handler.fileCount }
    }

    // MARK: - Init
    init(handler: PersistentHandler) {
        self.handler = handler
    }

    // Default
    init?(config: DiskConfigurable) {

        // Try to create default DiskPersistentHandler
        guard let handler = try? DiskPersistentHandler(config: config) else {
            return nil
        }

        self.handler = handler
    }

    // MARK: - Public
    func item(forKey key: Key) -> ItemType? {
        return queue.syncWithReturnedValue {
            try? handler.get(key: key, type: ItemType.self)
        }
    }

    func set(item: ItemType, forKey key: Key) {
        queue.async(flags: .barrier) { [unowned self] in

            // Don't handle Throws error here
            try? self.handler.write(item, key: key, attribute: nil)
        }
    }

    func getAllItems() -> [ItemType] {
        return queue.syncWithReturnedValue {
            guard let items = try? handler.getAll(type: ItemType.self) else {
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
