//
//  Counting.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

public struct Counting: Metric, Codable {
    var name: String
    var value: String
    var sample: Float?

    init(name: String, value: Int, sample: Float? = nil) {
        self.init(name: name, value: "\(value)", sample: sample)
    }

    init(name: String, value: String, sample: Float? = nil) {
        self.name = name
        self.value = value
        self.sample = sample
    }

    public var metricData: String {
        if let sample = sample {
            return "\(name):\(value)|c|@\(sample.clean)"
        }
        return "\(name):\(value)|c"
    }
}
