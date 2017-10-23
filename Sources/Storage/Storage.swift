//
//  Storage.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol Storage {
    associatedtype Key: Equatable
    associatedtype Item

    var count: Int { get }

    func item(forKey key: Key) -> Item?
    func set(item: Item, forKey key: Key) throws
    func getAll() -> [Item]
    func remove(key: String) throws
    func removeAll() throws
}

extension Storage {

    var isEmpty: Bool {
        // swiftlint:disable:next empty_count
        return count == 0
    }
}
