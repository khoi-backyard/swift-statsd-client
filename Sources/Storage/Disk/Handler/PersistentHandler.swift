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

    var fileCount: Int { get }

    func makeFilePath(_ key: CustomStringConvertible) -> String

    func write<T: Codable>(_ item: T, key: CustomStringConvertible, attribute: [FileAttributeKey: Any]?) throws

    func get<T: Codable>(key: CustomStringConvertible, type: T.Type) throws -> T

    func getAll<T: Codable>(type: T.Type) throws -> [T]

    func deleteFile(_ key: CustomStringConvertible) throws

    func deleteAllFile() throws
}
