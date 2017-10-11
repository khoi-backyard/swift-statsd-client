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

    func makeFilePath(_ key: Base64Transformable) -> String

    func write<T: Codable>(_ item: T, key: Base64Transformable, attribute: [FileAttributeKey: Any]?) throws

    func get<T: Codable>(key: Base64Transformable, type: T.Type) throws -> T

    func getAll<T: Codable>(type: T.Type) throws -> [T]

    func deleteFile(_ key: Base64Transformable) throws

    func deleteAllFile() throws
}
