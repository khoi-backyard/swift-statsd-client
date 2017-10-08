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

    var count: Int

    // MARK: - Init
    init(config: DiskConfigurable, handler: PersistentHandler) {
        self.config = config
        self.handler = handler
        count = 0
    }
    
    // MARK: - Public
    func item(forKey key: Key) -> Element? {
        return try? handler.get(key: key)
    }

    func set(item: Element, forKey key: Key) {
        try? handler.write(item, key: key, attribute: nil)
    }

    func getAllItems() -> [Element] {
        return []
    }

    func remove(key: String) {

    }

    func removeAll() {

    }

}
