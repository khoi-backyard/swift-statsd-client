//
//  DiskConfigurable.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol DiskConfigurable {

    // Name
    // It's also name of folder cache
    var name: String { get }

    // Max size on bytes
    var maxSize: UInt { get }

    // Cache folder type
    var directoryType: DirectoryType { get }

    // Protection mode in iOS/tvOS
    var protectionType: FileProtectionType? { get }
}

extension DiskConfigurable {

    // Default folder Type
    var directoryType: DirectoryType {
        return .cache
    }

    // Default cache folder
    var directory: URL? {
        return try? FileManager.default.url(for: directoryType.toSearchPath,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: true)
    }

    // Path folder by directory + name
    var pathFolder: String? {
        return directory?.appendingPathComponent(name, isDirectory: true).path
    }
}
