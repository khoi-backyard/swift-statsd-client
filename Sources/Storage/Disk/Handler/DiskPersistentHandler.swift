//
//  DiskManager.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

class DiskPersistentHandler: PersistentHandler {

    fileprivate let fileManager: FileManager
    fileprivate let folderPath: String
    fileprivate let encoder = JSONEncoder()
    fileprivate let decoder = JSONDecoder()

    public let config: DiskConfigurable
    public var fileCount: Int { return allFileURLs().count }

    init(config: DiskConfigurable, fileManager: FileManager = .default) throws {

        guard let folderPath = config.folderPath else {
            throw DiskError.invalidCacheFolder
        }

        self.config = config
        self.fileManager = fileManager
        self.folderPath = folderPath

        try createCacheFolder()
    }

    func makeFilePath(_ key: CustomStringConvertible) -> String {
        return "\(folderPath)/\(key)"
    }

    func write<T: Codable>(_ item: T, key: CustomStringConvertible, attribute: [FileAttributeKey: Any]?) throws {
        let pathFile = makeFilePath(key)
        let data = try encoder.encode(item)

        try createCacheFolder()
        guard fileManager.createFile(atPath: pathFile, contents: data, attributes: attribute) else {
            throw DiskError.unableWriteFile
        }
    }

    func get<T: Codable>(key: CustomStringConvertible, type: T.Type) throws -> T {
        let pathFile = makeFilePath(key)
        let urlFile = URL(fileURLWithPath: pathFile)
        let data = try Data(contentsOf: urlFile, options: .alwaysMapped)
        return try decoder.decode(T.self, from: data)
    }

    func getAll<T: Codable>(type: T.Type) -> [T] {

        let fileURLs = allFileURLs()

        return fileURLs.flatMap { url in
            guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else {
                return nil
            }
            return try? decoder.decode(T.self, from: data)
        }
    }

    func deleteFile(_ key: CustomStringConvertible) throws {
        let pathFile = makeFilePath(key)
        try fileManager.removeItem(atPath: pathFile)
    }

    func deleteAllFile() throws {
        try fileManager.removeItem(atPath: folderPath)
    }
}

extension DiskPersistentHandler {

    fileprivate func createCacheFolder() throws {

        var isDirectory: ObjCBool = false
        fileManager.fileExists(atPath: folderPath, isDirectory: &isDirectory)
        guard !isDirectory.boolValue else {
            return
        }

        try fileManager.createDirectory(atPath: folderPath,
                                        withIntermediateDirectories: true,
                                        attributes: nil)
    }

    fileprivate func allFileURLs() -> [URL] {

        let url = URL(fileURLWithPath: folderPath)
        let fileURLs = try? fileManager.contentsOfDirectory(at: url,
                                                            includingPropertiesForKeys: nil,
                                                            options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        return fileURLs ?? []
    }
}
