//
//  FileStorage.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

class FileStorage<ItemType>: MemoryStorage<ItemType> {
    private let fileManager: FileManager
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private lazy var storageUrl: URL = {
        // swiftlint:disable:next force_try
        let url = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("StatsD_Storage", isDirectory: false)

        if !fileManager.fileExists(atPath: url.path) {
            fileManager.createFile(atPath: url.path, contents: .init(), attributes: nil)
        }

        return url
    }()

    override internal var internalStorage: [String: ItemType] {
        // swiftlint:disable force_try
        get {
            let data = try! Data(contentsOf: storageUrl)
            let storage = try? decoder.decode([String: ItemType].self, from: data)
            return storage ?? [:]
        }
        set {
            let data = try! encoder.encode(newValue)
            try! data.write(to: storageUrl)
        }
        // swiftlint:enable force_try
    }

    init(fileManager: FileManager = .default, decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.fileManager = fileManager
        self.decoder = decoder
        self.encoder = encoder
        super.init(dispatchQueueLabel: "StatsD_FileStorage")
    }
}
