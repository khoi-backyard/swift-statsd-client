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
        metricData = metrics.map { $0.metricData }.joined(separator: "\n")
    }
}
