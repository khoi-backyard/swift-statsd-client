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

    // Expiry - apply to all entry
    var expiry: Expiry { get }

    // Max size on bytes
    var maxSize: UInt { get }

    // Default directly
    var directory: URL? { get }

    // Protection mode in iOS/tvOS
    var protectionType: FileProtectionType? { get }
}

extension DiskConfigurable {

    // Default cache folder
    var directory: URL? {
        return try? FileManager.default.url(for: .cachesDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true)
    }

    var pathFolder: String? {
        return directory?.appendingPathComponent(name, isDirectory: true).path
    }
}
