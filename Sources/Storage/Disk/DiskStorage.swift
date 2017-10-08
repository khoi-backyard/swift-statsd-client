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
    private let handler: PersistenceHandler
    private let queue = DispatchQueue(label: "StatsD_DiskStorage", qos: .default, attributes: .concurrent)

    var count: Int

    // MARK: - Init
    init(config: DiskConfigurable, handler: PersistenceHandler) {
        self.config = config
        self.handler = handler
        count = 0
    }

    // MARK: - Public
    func item(forKey key: Key) -> Element? {
        let path = handler.makeFilePath(key)
        return handler.get(path: path)
    }

    func set(item: Element, forKey key: Key) {
        let path = handler.makeFilePath(key)
        let data = item.encode()
        handler.write(data, path: path)
    }

    func getAllItems() -> [Element] {
        return []
    }

    func remove(key: String) {

    }

    func removeAll() {

    }

}
