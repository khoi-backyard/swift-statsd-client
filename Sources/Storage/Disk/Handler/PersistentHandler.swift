//
//  PersistanceHandler.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol PersistentHandler {

    var config: DiskConfigurable { get }

    func getTotal() -> Int

    func makeFilePath(_ key: String) -> String

    func write<T: Serializable>(_ item: T, key: String, attribute: [FileAttributeKey: Any]?) throws

    func get<T: Serializable>(key: String, type: T.Type) throws -> T

    func getAll<T: Serializable>(type: T.Type) throws -> [T]

    func deleteFile(_ key: String) throws

    func deleteAllFile() throws
}
