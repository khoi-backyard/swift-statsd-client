//
//  Batch.swift
//  StatsdClient
//
//  Created by Khoi Lai on 2/26/18.
//  Copyright © 2018 StatsdClient. All rights reserved.
//

import Foundation

public struct Batch: Metric {
    
    public var metricData: String
    
    init(metrics: Metric...) {
        metricData = ""
        for (i, m) in metrics.enumerated() {
            metricData += i == metrics.count - 1 ? "\(m.metricData)" : "\(m.metricData)\n"
        }
    }
}
