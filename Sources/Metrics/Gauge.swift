//
//  Gauge.swift
//  StatsdClient
//
//  Created by Khoi Lai on 10/7/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

struct Gauge: Metric {
    var name: String
    var value: String

    private init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    init(name: String, value: UInt) {
        self.init(name: name, value: "\(value)")
    }

    init(name: String, delta: Int) {
        let prefix = delta >= 0 ? "+" : "-"
        self.init(name: name, value: "\(prefix)\(abs(delta))")
    }

    var metricData: String {
        return "\(name):\(value)|g"
    }
}
