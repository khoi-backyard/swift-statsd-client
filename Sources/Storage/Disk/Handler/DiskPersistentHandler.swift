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
    fileprivate let defaultEnumerator: [URLResourceKey] = [
        .isDirectoryKey,
        .contentModificationDateKey,
        .totalFileAllocatedSizeKey,
    ]

    // Config
    public let config: DiskConfigurable

    // MARK: - Init
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

    func write<T: Codable>(_ item: T, key: String, attribute: [FileAttributeKey: Any]?) throws {
        let pathFile = makeFilePath(key)
        let data = try JSONEncoder().encode(item)
        handler.createFile(atPath: pathFile, contents: data, attributes: attribute)
    }

    func get<T: Codable>(key: String, type: T.Type) throws -> T {
        let pathFile = makeFilePath(key)
        let data = try Data(contentsOf: pathFile.fileURL(), options: .alwaysMapped)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func getAll<T: Codable>(type: T.Type) throws -> [T] {

        // Get all URLs in directory folder
        let fileURLs = allFileURLs()

        // Map to T
        let decoder = JSONDecoder()
        return try fileURLs.map { (url) -> T in
            let data = try Data(contentsOf: url, options: .alwaysMapped)
            return try decoder.decode(T.self, from: data)
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
        return allFileURLs().count
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
