//
//  Metric.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

public protocol Metric {
    var name: String { get }
    var value: String { get }
    var metricData: String { get }
    var sample: Float? { get }
}
