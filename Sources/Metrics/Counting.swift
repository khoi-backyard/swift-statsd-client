//
//  Counting.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

struct Counting: Metric, Sampleable {
    var name: String
    var value: Int
    var sample: Float?

    init(name: String, value: Int, sample: Float? = nil) {
        self.name = name
        self.value = value
        self.sample = sample
    }
    
    var metricData: String {
        if let sample = sample {
            return "\(name):\(value)|c|@\(sample.clean)"
        }
        return "\(name):\(value)|c"
    }
}
