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
    func set(item: Item, forKey key: Key)
    func getAllItems() -> [Item]
    func remove(key: String)
    func removeAll()
}
