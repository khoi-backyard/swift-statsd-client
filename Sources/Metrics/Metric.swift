//
//  Metric.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol Metric {
    var id: String { get } // swiftlint:disable:this identifier_name
    var name: String { get }
    var value: String { get }
    var metricData: String { get }
    var sample: Float? { get }
}

extension Metric {
    var id: String { // swiftlint:disable:this identifier_name
        return ProcessInfo.processInfo.globallyUniqueString
    }
}
