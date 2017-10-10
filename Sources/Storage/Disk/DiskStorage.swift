//
//  DiskStorage.swift
//  StatsdClient-iOS
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

final class DiskStorage<Element: Codable>: Storage {

    typealias Key = String
    typealias Item = Element

    // MARK: - Variable
    private let handler: PersistentHandler
    private let queue = DispatchQueue(label: "StatsD_DiskStorage", qos: .default, attributes: .concurrent)

    // Count
    var count: Int {
        return queue.syncWithReturnedValue { self.handler.getTotal() }
    }

    // MARK: - Init
    init(handler: PersistentHandler) {
        self.handler = handler
    }

    // Default
    init?(config: DiskConfigurable) {

        // Try to create default DiskPersistentHandler
        let handler = try? DiskPersistentHandler(config: config)

        // Make sure we could create proper DiskHandler with config
        guard let disk = handler else {
            return nil
        }

        // Save
        self.handler = disk
    }

    // MARK: - Public
    func item(forKey key: Key) -> Element? {
        return queue.syncWithReturnedValue {
            try? handler.get(key: key, type: Element.self)
        }
    }

    func set(item: Element, forKey key: Key) {
        queue.async(flags: .barrier) { [unowned self] in

            // Don't handle Throws error here
            try? self.handler.write(item, key: key, attribute: nil)
        }
    }

    func getAllItems() -> [Element] {
        return queue.syncWithReturnedValue {
            let items = try? handler.getAll(type: Element.self)
            return items ?? []
        }
    }

    func remove(key: String) throws {
        try queue.sync { [unowned self] in
            try self.handler.deleteFile(key)
        }
    }

    func removeAll() throws {
        try queue.sync { [unowned self] in
            try self.handler.deleteAllFile()
        }
    }
}
