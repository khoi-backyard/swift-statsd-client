//
//  DiskConfigurable.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol DiskConfigurable {

    var name: String { get }

    var maxSize: UInt { get }

    var directoryType: Directory { get }
}

extension DiskConfigurable {

    var directoryType: Directory {
        return .cache
    }

    var directory: URL? {
        return try? FileManager.default.url(for: directoryType.toSearchPath,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: true)
    }

    var folderPath: String? {
        return directory?.appendingPathComponent(name, isDirectory: true).path
    }
}
