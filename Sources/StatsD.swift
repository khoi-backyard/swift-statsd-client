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

    func increment(_ bucket: String, by value: Int)
    func set(_ bucket: String, value: String)
    func timing(_ bucket: String, value: Int)
    func gauge(_ bucket: String, value: UInt)
    func gauge(_ bucket: String, delta: Int)
}

public class StatsD: NSObject, StatsdProtocol {

    let transport: Transport

    init(transport: Transport) {
        self.transport = transport
    }

    public func increment(_ bucket: String, by value: Int = 1) {
        transport.write(data: Counting(name: bucket, value: "\(value)").metricData, completion: nil)
    }

    public func set(_ bucket: String, value: String) {
        transport.write(data: Sets(name: bucket, value: value).metricData, completion: nil)
    }

    public func timing(_ bucket: String, value: Int) {
        transport.write(data: Timing(name: bucket, value: value).metricData, completion: nil)
    }

    public func gauge(_ bucket: String, value: UInt) {
        transport.write(data: Gauge(name: bucket, value: value).metricData, completion: nil)
    }

    public func gauge(_ bucket: String, delta: Int) {
        transport.write(data: Gauge(name: bucket, delta: delta).metricData, completion: nil)
    }
    
    public func write(metricData: String) {
        transport.write(data: metricData, completion: nil)
    }
}
