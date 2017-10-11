//
//  DiskConfiguration.swift
//  StatsdClient
//
//  Created by Nghia Tran on 10/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

struct DiskConfiguration: DiskConfigurable {

    static let `default` = DiskConfiguration(name: "StatsD_DiskStorage", maxSize: 0)

    var name: String

    var maxSize: UInt
}
