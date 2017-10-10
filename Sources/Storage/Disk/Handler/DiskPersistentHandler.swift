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
    fileprivate let handler: FileManager
    fileprivate let path: String
    public let config: DiskConfigurable

    fileprivate let defaultEnumerator: [URLResourceKey] = [
        .isDirectoryKey,
        .contentModificationDateKey,
        .totalFileAllocatedSizeKey,
    ]

    init(config: DiskConfigurable, hanlder: FileManager = FileManager.default) throws {
        self.config = config
        self.handler = hanlder

        // Create path
        guard let pathFolder = config.pathFolder else {
            throw DiskError.invalidCacheFolder
        }

        path = pathFolder

        // Try to create folder
        try createCacheFolder()
    }

    // MARK: - Public
    func makeFilePath(_ key: String) -> String {
        return "\(path)/\(key.toBase64())"
    }

    func write<T: Serializable>(_ item: T, key: String, attribute: [FileAttributeKey: Any]?) throws {
        let pathFile = makeFilePath(key)
        let data = item.encode()
        handler.createFile(atPath: pathFile, contents: data, attributes: attribute)
    }

    func get<T: Serializable>(key: String, type: T.Type) throws -> T {
        let pathFile = makeFilePath(key)
        let data = try Data(contentsOf: pathFile.fileURL(), options: .alwaysMapped)
        return T(data: data)
    }

    func getAll<T: Serializable>(type: T.Type) throws -> [T] {

        // Get all URLs in directory folder
        let fileURLs = allFileURLs()

        // Map to T
        return try fileURLs.map { (url) -> T in
            let data = try Data(contentsOf: url, options: .alwaysMapped)
            return T(data: data)
        }
    }

    func deleteFile(_ key: String) throws {
        let pathFile = makeFilePath(key)
        try handler.removeItem(atPath: pathFile)
    }

    func deleteAllFile() throws {
        try handler.removeItem(atPath: path)
        try createCacheFolder()
    }

    func getTotal() -> Int {
        let files = allFileURLs()
        let count = files.count
        print("Count = \(count), file = \(files)")
        return count
    }
}

extension DiskPersistentHandler {

    fileprivate func createCacheFolder() throws {

        // Make sure it isn't existed
        guard handler.fileExists(atPath: path) == false else {
            return
        }

        // Create
        try handler.createDirectory(atPath: path,
                                    withIntermediateDirectories: true,
                                    attributes: nil)

    }

    fileprivate func allFileURLs() -> [URL] {

        // Get Directory
        let parentURL = path.fileURL()

        // Enumator
        let enumerator = handler.enumerator(at: parentURL,
                                            includingPropertiesForKeys: defaultEnumerator,
                                            options: .skipsHiddenFiles,
                                            errorHandler: nil)

        // Check if someone is not a URL
        guard let fileURLs = enumerator?.allObjects as? [URL] else {
            return []
        }

        return fileURLs
    }
}
