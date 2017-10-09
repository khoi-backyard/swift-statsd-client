//
//  DiskStorage.swift
//  StatsdClient-iOS
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

final class DiskStorage<Element: Serializable>: Storage {

    typealias Key = String
    typealias Item = Element

    // MARK: - Variable
    private let handler: PersistentHandler
    private let queue = DispatchQueue(label: "StatsD_DiskStorage", qos: .default, attributes: .concurrent)

    // Count
    fileprivate lazy var _count: Int = { return self.handler.getTotal() }()
    var count: Int { return _count }

    // MARK: - Init
    init(handler: PersistentHandler) {
        self.handler = handler
    }

    // Default
    init(config: DiskConfigurable) throws {
        self.handler = try DiskPersistentHandler(config: config)
    }

    // MARK: - Public
    func item(forKey key: Key) throws -> Element?  {
        return try queue.syncWithReturnedValue {
            try handler.get(key: key)
        }
    }

    func set(item: Element, forKey key: Key) {
      queue.async(flags: .barrier) { [unowned self] in

            // Don't handle Throws error here
            try? self.handler.write(item, key: key, attribute: nil)
            self._count += 1
        }
    }

    func getAllItems() throws -> [Element]  {
        return queue.syncWithReturnedValue {
            let items: [Element]? = try? handler.getAll()
            return items ?? []
        }
    }

    func remove(key: String) throws {
        try queue.sync { [unowned self] in
            try self.handler.deleteFile(key)
            self._count -= 1
        }
    }

    func removeAll() throws {
        try queue.sync { [unowned self] in
            try self.handler.deleteAllFile()
            self._count = 0
        }
    }
}
