//
//  Sets.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/20/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

struct Sets: Metric, Codable {
    var name: String
    var value: String
    let sample: Float? = nil

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    var metricData: String {
        return "\(name):\(value)|s"
    }
}
