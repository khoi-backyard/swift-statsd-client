//
//  Stats.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

public typealias StatsDCompletionCallback = (_ succes: Bool) -> Void

protocol StatsDProtocol {

    var transport: Transport { get }

    func increment(_ bucket: String, by value: Int, completion: StatsDCompletionCallback?)
    func set(_ bucket: String, value: String, completion: StatsDCompletionCallback?)
    func timing(_ bucket: String, value: Int, completion: StatsDCompletionCallback?)
    func gauge(_ bucket: String, value: UInt, completion: StatsDCompletionCallback?)
    func gauge(_ bucket: String, delta: Int, completion: StatsDCompletionCallback?)
}

public class StatsD: NSObject, StatsDProtocol {

    let transport: Transport

    public init(transport: Transport) {
        self.transport = transport
    }

    public func increment(_ bucket: String, by value: Int = 1, completion: StatsDCompletionCallback? = nil) {
        write(metric: Counting(name: bucket, value: "\(value)"), completion: completion)
    }

    public func set(_ bucket: String, value: String, completion: StatsDCompletionCallback? = nil) {
        write(metric: Sets(name: bucket, value: value), completion: completion)
    }

    public func timing(_ bucket: String, value: Int, completion: StatsDCompletionCallback? = nil) {
        write(metric: Timing(name: bucket, value: value), completion: completion)
    }

    public func gauge(_ bucket: String, value: UInt, completion: StatsDCompletionCallback? = nil) {
        write(metric: Gauge(name: bucket, value: value), completion: completion)
    }

    public func gauge(_ bucket: String, delta: Int, completion: StatsDCompletionCallback? = nil) {
        write(metric: Gauge(name: bucket, delta: delta), completion: completion)
    }

    public func write(metric: Metric, completion: StatsDCompletionCallback? = nil) {
        write(payload: metric.metricData, completion: completion)
    }

    public func write(payload: String, completion: StatsDCompletionCallback? = nil) {
        transport.write(data: payload) { (error) in
            completion?(error == nil)
        }
    }
}
