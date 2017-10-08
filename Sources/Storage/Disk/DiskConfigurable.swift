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

    var directory: URL? { get }

    var protectionType: FileProtectionType? { get }
}
