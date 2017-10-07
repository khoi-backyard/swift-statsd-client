//
//  Metric.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol Metric {
    associatedtype ValueType

    var name: String { get }
    var value: ValueType { get }
    var metricData: String { get }
}

protocol Sampleable {
    var sample: Float? { get }
}
