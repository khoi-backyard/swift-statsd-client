//
//  Stats.swift
//  StatsdClient
//
//  Created by Khoi Lai on 9/8/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import Foundation

public typealias StatsDCompletionCallback = (_ succes: Bool) -> Void

protocol StatsdProtocol {

    var transport: Transport { get }

    func increment(_ bucket: String, by value: Int, completion: StatsDCompletionCallback?)
    func set(_ bucket: String, value: String, completion: StatsDCompletionCallback?)
    func timing(_ bucket: String, value: Int, completion: StatsDCompletionCallback?)
    func gauge(_ bucket: String, value: UInt, completion: StatsDCompletionCallback?)
    func gauge(_ bucket: String, delta: Int, completion: StatsDCompletionCallback?)
}

public class StatsD: NSObject, StatsdProtocol {

    let transport: Transport

    public init(transport: Transport) {
        self.transport = transport
    }

    public func increment(_ bucket: String, by value: Int = 1, completion: StatsDCompletionCallback? = nil) {
        transport.write(data: Counting(name: bucket, value: "\(value)").metricData) { (error) in
            completion?(error == nil)
        }
    }

    public func set(_ bucket: String, value: String, completion: StatsDCompletionCallback? = nil) {
        transport.write(data: Sets(name: bucket, value: value).metricData) { (error) in
            completion?(error == nil)
        }
    }

    public func timing(_ bucket: String, value: Int, completion: StatsDCompletionCallback? = nil) {
        transport.write(data: Timing(name: bucket, value: value).metricData) { (error) in
            completion?(error == nil)
        }
    }

    public func gauge(_ bucket: String, value: UInt, completion: StatsDCompletionCallback? = nil) {
        transport.write(data: Gauge(name: bucket, value: value).metricData) { (error) in
            completion?(error == nil)
        }
    }

    public func gauge(_ bucket: String, delta: Int, completion: StatsDCompletionCallback? = nil) {
        transport.write(data: Gauge(name: bucket, delta: delta).metricData) { (error) in
            completion?(error == nil)
        }
    }

    public func write(metric: Metric, completion: StatsDCompletionCallback? = nil) {
        transport.write(data: metric.metricData) { (error) in
            completion?(error == nil)
        }
    }

    public func write(payload: String, completion: StatsDCompletionCallback? = nil) {
        transport.write(data: payload) { (error) in
            completion?(error == nil)
        }
    }
}
