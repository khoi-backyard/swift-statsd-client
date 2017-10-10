//
//  DiskConfiguration.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

struct DiskConfiguration: DiskConfigurable {

    var name: String { return "StatsD_DiskStorage" }

    var maxSize: UInt { return 0 }

    var protectionType: FileProtectionType? { return nil }

    var directoryType: DirectoryType { return .cache }
}
