//
//  Stats.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

protocol StatsdProtocol {
    var transport: Transport { get }
    func increment(bucket: String, value: Int)
    func set(bucket: String, value: String)
}

public class StatsD: StatsdProtocol {
    let transport: Transport

    public init(transport: Transport) {
        self.transport = transport
    }

    public func increment(bucket: String, value: Int = 1) {
        transport.write(data: Counting(name: bucket, value: value).metricData, completion: nil)
    }

    public func set(bucket: String, value: String) {
        transport.write(data: Sets(name: bucket, value: value).metricData, completion: nil)
    }
}
