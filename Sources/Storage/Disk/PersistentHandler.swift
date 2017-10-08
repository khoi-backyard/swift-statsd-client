//
//  PersistanceHandler.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol PersistentHandler {

    func makeFilePath(_ key: String) -> String
    func write<T: Serializable>(_ item: T, key: String, attribute: [FileAttributeKey: Any]?) throws
    func get<T: Serializable>(key: String) throws -> T
}
