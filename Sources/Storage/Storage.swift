//
//  Storage.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol Storage {
    associatedtype Item

    var count: Int { get }

    func item(forKey key: String) -> Item?
    func set(item: Item, forKey key: String)
    func getAllItems() -> [Item]
    func remove(item: Item, forKey key: String)
    func removeAll()
}
