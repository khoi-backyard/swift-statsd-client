//
//  DiskManager.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

class DiskPersistentHandler: PersistentHandler {


    // MARK: - Variable
    private let handler: FileManager

    init(hanlder: FileManager = FileManager.default) {
        self.handler = hanlder
    }
    
    // MARK: - Public
    func makeFilePath(_ key: String) -> String {
        return key.toBase64()
    }

    func write<T: Serializable>(_ item: T, key: String, attribute: [FileAttributeKey: Any]?) throws {
        let path = makeFilePath(key)
        let data = item.encode()
        handler.createFile(atPath: path, contents: data, attributes: attribute)
    }

    func get<T: Serializable>(key: String) throws -> T {
        let path = makeFilePath(key)
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.alwaysMapped)
        return T(data: data)
    }
}
