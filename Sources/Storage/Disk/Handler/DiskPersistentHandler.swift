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
    fileprivate let fileManager: FileManager
    fileprivate let pathFolder: String
    fileprivate let encoder = JSONEncoder()
    fileprivate let decoder = JSONDecoder()
    fileprivate let defaultEnumerator: [URLResourceKey] = [
        .isDirectoryKey,
        .contentModificationDateKey,
        .totalFileAllocatedSizeKey,
    ]

    public let config: DiskConfigurable
    public var fileCount: Int { return allFileURLs().count }

    init(config: DiskConfigurable, fileManager: FileManager = .default) throws {

        // Create path
        guard let pathFolder = config.pathFolder else {
            throw DiskError.invalidCacheFolder
        }

        self.config = config
        self.fileManager = fileManager
        self.pathFolder = pathFolder

        // Try to create folder
        try createCacheFolder()
    }

    func makeFilePath(_ key: Base64Transformable) -> String {
        return "\(pathFolder)/\(key.encoded())"
    }

    func write<T: Codable>(_ item: T, key: Base64Transformable, attribute: [FileAttributeKey: Any]?) throws {
        let pathFile = makeFilePath(key)
        let data = try encoder.encode(item)

        // Try to create folder if need
        try createCacheFolder()
        guard fileManager.createFile(atPath: pathFile, contents: data, attributes: attribute) else {
            throw DiskError.unableWriteFile
        }
    }

    func get<T: Codable>(key: Base64Transformable, type: T.Type) throws -> T {
        let pathFile = makeFilePath(key)
        let urlFile = URL(fileURLWithPath: pathFile)
        let data = try Data(contentsOf: urlFile, options: .alwaysMapped)
        return try decoder.decode(T.self, from: data)
    }

    func getAll<T: Codable>(type: T.Type) -> [T] {

        // Get all URLs in directory folder
        let fileURLs = allFileURLs()

        // Map to T
        return fileURLs.flatMap { url in
            guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else {
                return nil
            }
            return try? decoder.decode(T.self, from: data)
        }
    }

    func deleteFile(_ key: Base64Transformable) throws {
        let pathFile = makeFilePath(key)
        try fileManager.removeItem(atPath: pathFile)
    }

    func deleteAllFile() throws {
        try fileManager.removeItem(atPath: pathFolder)
    }
}

extension DiskPersistentHandler {

    fileprivate func createCacheFolder() throws {

        // Make sure it isn't existed
        guard fileManager.fileExists(atPath: pathFolder) == false else {
            return
        }

        // Create
        try fileManager.createDirectory(atPath: pathFolder,
                                        withIntermediateDirectories: true,
                                        attributes: nil)
    }

    fileprivate func allFileURLs() -> [URL] {

        // Get Directory
        let url = URL(fileURLWithPath: self.pathFolder)
        let fileURLs = try? fileManager.contentsOfDirectory(at: url,
                                                            includingPropertiesForKeys: nil,
                                                            options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        return fileURLs ?? []
    }
}
