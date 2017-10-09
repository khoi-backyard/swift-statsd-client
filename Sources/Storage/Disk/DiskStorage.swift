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
    private let config: DiskConfigurable
    private let handler: PersistentHandler
    private let queue = DispatchQueue(label: "StatsD_DiskStorage", qos: .default, attributes: .concurrent)

    // Count
    fileprivate var _count = 0
    var count: Int { return _count }

    // MARK: - Init
    init(config: DiskConfigurable, handler: PersistentHandler) {
        self.config = config
        self.handler = handler
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

    }

    func removeAll() throws {

    }

}
