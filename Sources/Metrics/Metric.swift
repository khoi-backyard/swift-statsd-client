//
//  Metric.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

public protocol Metric {
    var metricData: String { get }
}
